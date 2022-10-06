# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

/rw/config/rc.local:
  file.append:
    - text: |
        socat TCP-LISTEN:18081,fork,bind=127.0.0.1 EXEC:"qrexec-client-vm monerod-ws user.monerod"
