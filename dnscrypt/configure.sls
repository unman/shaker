# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}
new_resolv.conf:
  file.managed:
    - name: /rw/config/resolv.conf
    - source: salt://dnscrypt/resolv.conf

dnscrypt_update_rc.local:
  file.append:
    - name: /rw/config/rc.local
    - text: |
        cp /etc/resolv.conf /etc/resolv.conf.backup
        cp /rw/config/resolv.conf /etc/resolv.conf
  
/rw/config/qubes-firewall.d/update_nft.sh:
  file.managed:
    - source:
      - salt://dnscrypt/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/qubes-firewall.d/update_nft.nft:
  file.managed:
    - source:
      - salt://dnscrypt/update_nft.nft
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/update_nft.sh:
  file.managed:
    - source:
      - salt://dnscrypt/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/internalise.sh:
  file.managed:
    - source:
      - salt://dnscrypt/internalise.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

dnscrypt-set-localnet:
  cmd.run:
    - name: /usr/sbin/sysctl -w net.ipv4.conf.all.route_localnet=1

dnscrypt-configure:
  file.copy:
    - name:  /home/user/linux-x86_64/dnscrypt-proxy.toml
    - source: /home/user/linux-x86_64/example-dnscrypt-proxy.toml

{% endif %}
