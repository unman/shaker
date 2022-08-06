# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#

{% if grains['nodename'] != 'dom0' %}

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
      - /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'http://HTTPS///'
    - repl: 'https://'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]


{% set IP = salt['cmd.shell']('qubesdb-read /qubes-ip') %}
{% set GW = salt['cmd.shell']('qubesdb-read /qubes-gateway') %}

/etc/network/interfaces.d/eth0:
  file.managed:
    - source:
      - salt://pihole/eth0
    - user: root
    - group: root
    - makedirs: True

set_ip:
  file.line:
    - name: /etc/network/interfaces.d/eth0
    - match: address
    - mode: replace
    - content: "address {{IP}}"

set_gw:
  file.line:
    - name: /etc/network/interfaces.d/eth0
    - match: gateway
    - mode: replace
    - content: "gateway {{GW}}"

'systemctl restart networking':
  cmd.run:
    - runas: root

Pihole_update:
  pkg.uptodate:
    - refresh: True

Pihole_installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - curl
      - dnsutils
      - firefox-esr
      - git
      - idn2
      - lighttpd
      - netcat-openbsd
      - php-cgi
      - php-common
      - php-intl
      - php-json
      - php-sqlite3
      - php-xml
      - unzip

Pihole-systemd-mask:
  cmd.run:
    - name: systemctl disable systemd-resolved

https://github.com/pi-hole/pi-hole.git:
  git.latest:
    - name: https://github.com/pi-hole/pi-hole.git
    - user: root
    - target: /root/pi-hole

/etc/pihole/setupVars.conf:
  file.managed:
    - source:
      - salt://pihole/setupVars.conf
    - user: root
    - group: root
    - makedirs: True

Pihole-setup:
  cmd.run:
    - name: '/root/pi-hole/automated\ install/basic-install.sh --unattended'

/rw/config/qubes-firewall-user-script:
  file.append:
    - text:
      - nft flush chain nat PR-QBS
      - nft insert rule nat PR-QBS iifname "vif*" tcp dport 53 dnat to 127.0.0.1
      - nft insert rule nat PR-QBS iifname "vif*" udp dport 53 dnat to 127.0.0.1

/rw/config/qubes-firewall.d/update_nft.sh:
  file.managed:
    - source:
      - salt://pihole/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/internalise.sh:
  file.managed:
    - source:
      - salt://pihole/internalise.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/flush.sh:
  file.managed:
    - source:
      - salt://pihole/flush.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/network-hooks.d/flush:
  file.managed:
    - source:
      - salt://pihole/flush
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/etc/dnsmasq.conf:
  file.prepend:
    - text:
      - interface=lo
      - bind-interfaces

{% endif %}
