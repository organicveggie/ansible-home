#!/bin/bash
set -eEuo pipefail

# systemd unit
UNIT='restic-backup.service'

# Telegraf InfluxDB v2 listener
TELEGRAF_LISTENER='http://localhost:{{ telegraf_plugin_influxdb2_v2_port }}'

LOGS=

function error_finalizer() {
    write_metrics "restic_backup_failure failure=1 $(date '+%s')000000000"
}

trap "error_finalizer" ERR

function write_metrics() {
    local metric="$1"
    curl -i -XPOST "${TELEGRAF_LISTENER}/api/v2/write" --data-binary "${metric}"
}

function main() {
    local log_file="${1:-}"
    if [ -n "${log_file}" ]; then
        # Get logs from file (useful for debugging / testing)
        LOGS="$(cat {$log_file})"
    else
        # Find last invocation
        local id=$(systemctl show -p InvocationID --value "${UNIT}")
        
        # Retrieve logs from last invocation
        LOGS="$(journalctl -o short-iso _SYSTEMD_INVOCATION_ID=${id} --output json)" 
    fi

    # Check for failure
    if echo "$LOGS" | grep -F "${UNIT}: Failed with result"; then
        # jumps to error_finalizer
        return 1
    fi

    # Convert full logs into simplified JSON logs
    local systemd_json_logs="$(echo ${LOGS} | jq '{"host": ._HOSTNAME, "machine_id": ._MACHINE_ID,
        "systemd_unit": ._SYSTEMD_UNIT, "syslog_id": .SYSLOG_IDENTIFIER, "timestamp": .__MONOTONIC_TIMESTAMP,
        "message": .MESSAGE}')"

    # Filter out null/empty messages
    local systemd_message_logs="$(echo ${systemd_json_logs} | jq 'select(.message != null)')"

    # Pull out the systemd record which contains the restic summary data
    local systemd_summary_record="$(echo ${systemd_message_logs} | jq 'select(.message | contains("summary"))')"

    # Extract summary data and convert it to valid JSON
    local summary="$(echo ${systemd_summary_record} | jq -c '.message' \
        | grep "message_type" \
        | sed 's/\\"/"/g' \
        | sed 's/^"//' \
        | sed 's/"$//')"

    # Sample summary JSON:
    #
    # {
    #     "message_type": "summary",
    #     "files_new": 0, "files_changed": 3, "files_unmodified": 6529,
    #     "dirs_new": 0, "dirs_changed": 4, "dirs_unmodified": 2014,
    #     "data_blobs": 4, "tree_blobs": 5, "data_added": 1260799,
    #     "total_files_processed": 6532, "total_bytes_processed": 681851522,
    #     "total_duration": 0.987381565,
    #     "snapshot_id": "9da95561"
    # }

    local systemd_unit="$(echo ${systemd_summary_record} | jq '.systemd_unit')"
    local machine_id="$(echo ${systemd_summary_record} | jq '.machine_id')"
    local syslog_id="$(echo ${systemd_summary_record} | jq '.syslog_id')"
    local mono_timestamp="$(echo ${systemd_summary_record} | jq '.timestamp')"
    
    local extra_fields="systemd_unit=${systemd_unit},monotonic_timestamp=${mono_timestamp}"
    local extra_tags="machine_id=${machine_id},syslog_id=${syslog_id}"

    local timestamp_ns="$(date '+%s')000000000"

    local files_new="$(echo ${summary} | jq '.files_new')"
    local files_changed="$(echo ${summary} | jq '.files_changed')"
    local files_unmodified="$(echo ${summary} | jq '.files_unmodified')"
    local dirs_new="$(echo ${summary} | jq '.dirs_new')"
    local dirs_changed="$(echo ${summary} | jq '.dirs_changed')"
    local dirs_unmodified="$(echo ${summary} | jq '.dirs_unmodified')"
    local total_files_processed="$(echo ${summary} | jq '.total_files_processed')"
    local total_bytes_processed="$(echo ${summary} | jq '.total_bytes_processed')"
    local total_duration="$(echo ${summary} | jq '.total_duration')"
    local snapshot_id="$(echo ${summary} | jq '.snapshot_id')"
    
    # Syntax
    # <measurement>[,<tag_key>=<tag_value>[,<tag_key>=<tag_value>]] <field_key>=<field_value>[,<field_key>=<field_value>] [<timestamp>]
    write_metrics "restic_backup,${extra_tags} invocation_id=\"${id}\",files_new=${files_new},files_changed=${files_changed},files_unmodified=${files_unmodified},dirs_new=${dirs_new},dirs_changed=${dirs_changed},dirs_unmodified=${dirs_unmodified},total_files_processed=${total_files_processed},total_bytes_processed=${total_bytes_processed},total_duration=${total_duration},snapshot_id=${snapshot_id},${extra_fields} ${timestamp_ns}"

    return 0
}

main "$@"
