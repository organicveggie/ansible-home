#!/bin/bash

now=`date +%s%N`
zpool list -pH |awk -F '\t' '// { printf("zfs_pool_sizes,pool=\"%s\" total=%si,used=%si,free=%si\n", $1, $2, $3, $4); }'| sed 's/$/'" ${now}"'/'