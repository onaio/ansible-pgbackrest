pgBackRest Ansible Role [![Build Status](https://github.com/onaio/ansible-role/workflows/CI/badge.svg)](https://github.com/onaio/ansible-role/actions?query=workflow%3ACI)
=========

Ansible role that installs and configures [pgbackrest](https://pgbackrest.org/).

Requirements
------------

- This role assumes that postgresql server has been set up and configured with archiving configurations enabled on the postgresql hosts (pg-host).
````conf
archive_command = 'pgbackrest --stanza=<stanza> archive-push %p'
archive_mode = on
max_wal_senders = 3
wal_level = replica
archive_timeout = <desired_timeout>
````

Role Variables
--------------

Check the [defaults/main.yml](./defaults/main.yml) file for the full list of default variables.
> Ensure pgbackrest_is_pg_host and pgbackrest_is_repository_host are defined accordingly. 
> They are both true by default, this supports the most basic set up i.e. one host for pg-host and repo-host. If more than one host is involved update the respective boolean configs.
````yaml
---
pgbackrest_working_directory: /tmp/build
pgbackrest_version: 2.53

pgbackrest_git_repo_release_artifact_url: "https://github.com/pgbackrest/pgbackrest/archive/release/{{ pgbackrest_version }}.tar.gz"

pgbackrest_conf_template: "etc/pgbackrest/pgbackrest.conf.j2"
pgbackrest_config_path: "{{ pgbackrest_config_dir }}/pgbackrest.conf"
pgbackrest_config_dir: "/etc/pgbackrest"
pgbackrest_cert_directory: "{{ pgbackrest_config_dir }}/cert"

pgbackrest_service_template: "etc/systemd/system/pgbackrest.service.j2"
pgbackrest_service_path: "/etc/systemd/system/pgbackrest.service"

pgbackrest_setup_certificate: false
pgbackrest_certificate_ca:
pgbackrest_certificate_files:

pgbackrest_pre_install_packages:
  - wget
  - tar

pgbackrest_install_packages:
  - python3-distutils
  - meson
  - gcc
  - libpq-dev
  - libssl-dev
  - libxml2-dev
  - pkg-config
  - liblz4-dev
  - libzstd-dev
  - libbz2-dev
  - libz-dev
  - libyaml-dev
  - libssh2-1-dev

pgbackrest_cleanup_packages:
  - python3-distutils
  - meson
  - gcc
  - libpq-dev
  - libssl-dev
  - libxml2-dev
  - pkg-config
  - liblz4-dev
  - libzstd-dev
  - libbz2-dev
  - libz-dev
  - libyaml-dev
  - libssh2-1-dev

pgbackrest_binary_dir: /usr/bin
pgbackrest_binary_download_url:
pgbackrest_log_directory: /var/log/pgbackrest

pgbackrest_create_user: true
pgbackrest_user: postgres
pgbackrest_user_group: postgres
pgbackrest_user_password: 
pgbackrest_user_home: "/var/lib/postgresql"

pgbackrest_is_pg_host: true

pgbackrest_cleanup_after_setup: false

pgbackrest_is_repository_host: true

pgbackrest_repo_directories:
  - /var/lib/pgbackrest

pgbackrest_temp_ssh_pub_key_export_directory: "/tmp/ansible-pgbackrest-ssh-keys"

pgbackrest_ssh_pub_keys_to_import: []
#  - src_host: 192.168.15.21
#    authorized_keys_path: "{{ pgbackrest_user_home }}/.ssh/authorized_keys" # destination on current inventory_hostname
#    owner: "{{ pgbackrest_user }}"
#    group: "{{ pgbackrest_user_group }}"

pgbackrest_stanza_conf:
  - name: main
    content:
      pg1-path: /var/lib/postgresql/14/main
      repo1-block: y
      repo1-bundle: y
      compress-level: 3
      repo1-path: /var/lib/pgbackrest
      repo1-cipher-pass: zWaf6XtpjIVZC5444yXB+cgFDFl7MxGlgkZSaoPvTGirhPygu4jOKOXf9LO4vjfO
      repo1-cipher-type: aes-256-cbc
      repo1-retention-full: 1
      log-level-file: detail
      start-fast: y
      pg1-host-user: postgres

pgbackrest_conf:
  - name: global
    content:
      compress-level: 3
  - name: global:archive-push
    content:
      compress-level: 3

pgbackrest_cronjob:
  - name: pgbackrest_full_backup
    minute: "10"
    hour: "06"
    day: "*"
    month: "*"
    weekday: "0"
    user: "{{ pgbackrest_user }}"
    job: "pgbackrest --type=full --stanza=main backup"
    cron_file: pgbackrest
  - name: pgbackrest_diff_backup
    minute: "10"
    hour: "06"
    day: "*"
    month: "*"
    weekday: "1-6"
    user: "{{ pgbackrest_user }}"
    job: "pgbackrest --type=diff --stanza=main backup"
    cron_file: pgbackrest
````

Dependencies
------------

N/A

Example Playbook
----------------

Check for examples on the [example](./example) directory:
- [dedicated-repository-host-tls](./example/dedicated-repository-host-tls) with tls.
- [dedicated-repository-host-ssh](./example/dedicated-repository-host-ssh) with ssh.
- [same-repo-host-as-pg](./example/same-repo-host-as-pg).

License
-------

Apache 2
