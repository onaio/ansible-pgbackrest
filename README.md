pgBackRest Ansible Role [![CI](https://github.com/onaio/ansible-pgbackrest/actions/workflows/ci.yml/badge.svg)](https://github.com/onaio/ansible-pgbackrest/actions/workflows/ci.yml)
=========

Ansible role that installs and configures [pgbackrest](https://pgbackrest.org/).

1. **Apart from starting pgbackrest server for tls setups, no other pgbackrest commands are executed by this role.**
2. **Postgresql service is not affected by this role.**

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
> They are both true by default, this supports the most basic set up i.e. same host for pg-host and repo-host. If more than one host is involved update the respective boolean configs.
````yaml
---
pgbackrest_is_pg_host: true
pgbackrest_is_repository_host: true

pgbackrest_version: 2.53

# user not created on pg-host, re-using postgres user created when setting up postgresql service
pgbackrest_create_user: false
pgbackrest_user: postgres
pgbackrest_user_group: postgres
pgbackrest_user_home: "/var/lib/postgresql"

pgbackrest_cleanup_after_setup: true

pgbackrest_repo_directory: /var/lib/pgbackrest

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
