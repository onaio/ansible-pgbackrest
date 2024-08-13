# dedicated-repository-host
This demonstrates how one can configure dedicated host (backup server) with a postgresql host with tls.  

For production environments remember to encrypt credentials

````shell
ansible-vault encrypt dedicated-repository-host/inventory/files/tls/pg1.key --vault-password=.vault-pass
````

[create-tls.sh](../create-tls.sh) generates the certificates needed for the setup, modify the `common names` accordingly.
