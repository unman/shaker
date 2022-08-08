/rw/config/rc.local:
  file.append:
    - text: wg-quick up /rw/config/wireguard.conf

/rw/config/qubes-firewall-user-script:
  file.append:
    - text:
      - nft insert rule filter FORWARD tcp flags syn tcp option maxseg size set rt mtu
      - nft insert rule filter FORWARD oifname eth0 drop
      - nft insert rule filter FORWARD iifname eth0 drop

/rw/config/network-hooks.d/flush.sh:
  file.managed:
    - source:
      - salt://mullvad/flush.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/flush:
  file.managed:
    - source:
      - salt://mullvad/flush
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/home/user/install.sh:
  file.managed:
    - source:
      - salt://mullvad/install.sh
    - user: root
    - mode: '0755'
    - replace: True

