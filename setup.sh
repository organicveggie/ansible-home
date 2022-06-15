#!/bin/sh

python3 -m venv py38
source py38/bin/activate

echo py38/bin/python3 -m pip install --upgrade pip
py38/bin/python3 -m pip install --upgrade pip

echo py38/bin/python3 -m pip install "ansible"
py38/bin/python3 -m pip install "ansible"
echo py38/bin/python3 -m pip install "molecule="
py38/bin/python3 -m pip install "molecule"
echo py38/bin/python3 -m pip install "ansible-lint"
py38/bin/python3 -m pip install "ansible-lint"
echo py38/bin/python3 -m pip install "molecule[docker]"
py38/bin/python3 -m pip install "molecule[docker]"

# Package            Version
# ------------------ ---------
# ansible            2.10.7
# ansible-base       2.10.17
# ansible-compat     2.0.2
# ansible-core       2.12.5
# ansible-lint       4.3.7
# arrow              1.2.2
# autopep8           1.5.7
# bcrypt             3.2.0
# binaryornot        0.4.4
# boto               2.49.0
# boto3              1.17.0
# botocore           1.20.0
# Cerberus           1.3.2
# certifi            2021.5.30
# cffi               1.14.4
# chardet            4.0.0
# charset-normalizer 2.0.12
# click              8.1.3
# click-help-colors  0.9.1
# colorama           0.4.4
# commonmark         0.9.1
# cookiecutter       1.7.3
# cryptography       3.3.1
# docker             5.0.3
# enrich             1.2.7
# idna               3.3
# influxdb-client    1.19.0
# Jinja2             3.1.2
# jinja2-time        0.2.0
# jmespath           0.10.0
# MarkupSafe         2.1.1
# molecule           3.6.0
# molecule-docker    1.1.0
# packaging          20.8
# paramiko           2.10.4
# pep8               1.7.1
# pip                22.1
# pluggy             1.0.0
# poyo               0.5.0
# pycodestyle        2.7.0
# pycparser          2.20
# Pygments           2.7.4
# PyNaCl             1.5.0
# pyparsing          2.4.7
# python-dateutil    2.8.1
# python-slugify     6.1.2
# pytz               2021.1
# PyYAML             5.4.1
# requests           2.27.1
# resolvelib         0.5.4
# rich               9.10.0
# ruamel.yaml        0.16.12
# ruamel.yaml.clib   0.2.2
# Rx                 3.2.0
# s3transfer         0.3.4
# setuptools         51.3.3
# six                1.15.0
# subprocess-tee     0.3.5
# text-unidecode     1.3
# toml               0.10.2
# typing-extensions  3.7.4.3
# urllib3            1.26.3
# websocket-client   1.3.2
# wheel              0.36.2
