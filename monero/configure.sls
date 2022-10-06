# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

/home/user/monerod.service:
  file.managed:
    - source:
      - salt://monero/monerod.service
    - makedirs: True
    - user: user
    - group: user
    - mode: 644

/rw/config/rc.local:
  file.append:
    - text: |
        cp /home/user/monerod.service /lib/systemd/system
        systemctl start monerod.service

/rw/usrlocal/etc/qubes-rpc/user.monerod:
  file.append:
    - text: socat STDIO TCP:localhost:18081
    - makedirs: True
    
