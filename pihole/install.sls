# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#

{% if grains['nodename'] != 'dom0' %}
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
{{ repo }}_baseurl:
  file.replace:
    - name: {{ repo }}
    - pattern: 'http://HTTPS///'
    - repl: 'https://'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endfor %}

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
    - pattern: 'http://HTTPS///'
    - repl: 'https://'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]


{% set IP = salt['cmd.shell']('qubesdb-read /qubes-ip') %}
{% set GW = salt['cmd.shell']('qubesdb-read /qubes-gateway') %}

pihole-allow-testing:
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: false

/etc/network/interfaces.d/enX0:
  file.managed:
    - source:
      - salt://pihole/enX0
    - user: root
    - group: root
    - makedirs: True

set_ip:
  file.line:
    - name: /etc/network/interfaces.d/enX0
    - match: address
    - mode: replace
    - content: "address {{IP}}"

set_gw:
  file.line:
    - name: /etc/network/interfaces.d/enX0
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
      - qubes-core-agent-dom0-updates
      - curl
      - bind9-dnsutils
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

/rw/config/qubes-firewall.d/update_nft.sh:
  file.managed:
    - source:
      - salt://pihole/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/rw/config/qubes-firewall.d/update_nft.nft:
  file.managed:
    - source:
      - salt://pihole/update_nft.nft
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

/rw/config/network-hooks.d/update_nft.sh:
  file.managed:
    - source:
      - salt://pihole/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: 755

/etc/dnsmasq.conf:
  file.prepend:
    - text:
      - interface=lo
      - bind-interfaces

update_pihole_listening_mode:
  file.replace:
    - name: /etc/pihole/pihole.toml 
    - pattern: 'listeningMode = "LOCAL"'
    - repl: 'listeningMode = "ALL"'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}
