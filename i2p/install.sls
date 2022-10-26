# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

/usr/share/keyrings/i2p-archive-keyring.gpg:
  file.managed:
    - source:
      - salt://i2p/i2p-archive-keyring.gpg
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/etc/apt/sources.list.d/i2p.list:
  file.managed:
    - source:
      - salt://i2p/i2p.list
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

{% if salt['qvm.exists']('cacher') %}
{% if grains['os_family']|lower == 'debian' %}
{% if grains['nodename']|lower != 'host' %}
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
{% endif %}
{% endif %}

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - i2p
      - i2p-keyring

{% endif %}
