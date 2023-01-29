# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if salt['qvm.exists']('cacher') %}

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
      - /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endif %}

installed:
  pkg.installed:
    - pkgs:
      - openssh-server
      - socat

disable:
  cmd.run:
    - name: |
        systemctl stop ssh
        systemctl disable ssh
        systemctl mask ssh

/etc/qubes-rpc/qubes.ssh:
  file.append:
    - text: |
        #!/bin/sh
        exec socat STDIO TCP:localhost:22
