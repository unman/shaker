# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.append:
    - text: |
        binds+=( '/etc/cups/printers.conf' )
        binds+=( '/etc/qubes-rpc/qubes.Print' )
    - makedirs: True

create_qrexec:
  file.managed:
    - name: /rw/bind-dirs/etc/qubes-rpc/qubes.Print
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

/rw/bind-dirs/etc/qubes-rpc/qubes.Print:
  file.append:
    - text: |
        #!/bin/sh
        exec socat STDIO TCP:localhost:631
