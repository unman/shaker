# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/rw/config/rc.local:
  file.append:
    - text: |
        socat TCP4-LISTEN:9100,reuseaddr,fork EXEC:"qrexec-client-vm print qubes.Print"

/home/user/.cups/client.conf:
  file.append:
    - text: |
        Servername 127.0.0.1:9100
    - makedirs: True

