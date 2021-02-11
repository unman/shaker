# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.append:
    - text: |
        binds+=( '/etc/cups/printers.conf' )
        binds+=( '/etc/qubes-rpc/qubes.Print' )
    - makedirs: True

/rw/bind-dirs/etc/qubes-rpc/qubes.Print:
  file.append:
    - text: |
        #!/bin/sh
        exec socat STDIO TCP:localhost:631
    - makedirs: True
