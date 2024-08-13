#!/bin/bash
set -Euo pipefail
path=dedicated-repository-host/inventory/files/tls
root_ca_cn="root-ca"
pg1_cn="192.168.15.21"
repo1_cn="192.168.15.22"

openssl req -new -x509 -days 3650 -nodes -out $path/ca.crt -keyout $path/ca.key -subj "/CN=$root_ca_cn"
openssl req -new -nodes -out $path/repo1.csr -keyout $path/repo1.key -subj "/CN=$repo1_cn"
openssl req -new -nodes -out $path/pg1.csr -keyout $path/pg1.key -subj "/CN=$pg1_cn"
openssl x509 -req -in $path/repo1.csr -days 3650 -CA $path/ca.crt -CAkey $path/ca.key -CAcreateserial -out $path/repo1.crt
openssl x509 -req -in $path/pg1.csr -days 3650 -CA $path/ca.crt -CAkey $path/ca.key -CAcreateserial -out $path/pg1.crt
