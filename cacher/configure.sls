# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

cacher_/rw/config/rc.local:
  file.append:
    - name: /rw/config/rc.local
    - text: |
        systemctl unmask apt-cacher-ng
        systemctl start apt-cacher-ng
        /usr/sbin/nft insert rule qubes custom-input tcp dport 8082 accept

cacher_/rw/config/qubes-firewall-user-script:
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text: /usr/sbin/nft insert rule qubes custom-input tcp dport 8082 accept

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.managed:
    - source:
      - salt://cacher/50_user.conf
    - user: root
    - group: root
    - makedirs: True

{% endif %}
