# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if salt['pillar.get']('update_proxy:caching') %}
{% set proxy = 'cacher' %}
{% endif %}

{% if grains['nodename'] != 'dom0' %}
{% if grains['os_family']|lower == 'debian' %}
{% if grains['nodename']|lower != 'host' %}
{% if proxy  == 'cacher' %}
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
{{ repo }}_baseurl:
  file.replace:
    - name: {{ repo }}
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endfor %}

/etc/apt/sources.list:
  file.replace:
    - name: /etc/apt/sources.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - mate-notification-daemon
      - suricata
      - tcpdump
      - tcpflow
      - wireshark

systemd-disable-suricata:
  cmd.run:
    - name: systemctl disable suricata

systemd-mask-suricata:
  cmd.run:
    - name: systemctl mask suricata

{% endif %}
{% endif %}
{% endif %}
