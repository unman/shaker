/rw/config/qubes-firewall.d/set_forward.sh:
  file.managed:
    - source:
      - salt://mullvad/set_forward.sh
    - user: root
    - group: root
    - mode: '755'
    - makedirs: True

/rw/config/network-hooks.d/set_forward.sh:
  file.managed:
    - source:
      - salt://mullvad/set_forward.sh
    - user: root
    - group: root
    - mode: '755'
    - makedirs: True

/rw/config/qubes-firewall.d/update_dns.nft:
  file.managed:
    - source:
      - salt://mullvad/update_dns.nft
    - user: root
    - group: root
    - mode: '755'
    - makedirs: True

# Make settings persistent using bind-dirs
bind_mullvad_settings:
  file.append:
    - name: /rw/config/qubes-bind-dirs.d/50_user.conf
    - text: "binds+=( '/etc/mullvad-vpn' )"
    - makedirs: True
