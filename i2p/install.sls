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

{% if salt['pillar.get']('update_proxy:caching') %}
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

{% if salt['pillar.get']('update_proxy:caching') %}
i2p_list_cacher:
  file.replace:
    - name: /etc/apt/sources.list.d/i2p.list
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False
{% endif %}

i2p_upgrade:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

i2p_install:
  pkg.installed:
    - refresh: True
    - pkgs:
      - qubes-core-agent-networking
      - firefox-esr
      - i2p
      - i2p-keyring

i2p_untar_extension:
  archive.extracted:
    - name: /etc/skel/
    - source: salt://i2p/i2p_browser.tgz
    - user: root
    - group: root

i2p_disable_ipv6:
  file.append:
    - name: /etc/sysctl.conf
    - text: |
        net.ipv6.conf.all.disable_ipv6 = 1
        net.ipv6.conf.default.disable_ipv6 = 1
        net.ipv6.conf.lo.disable_ipv6 = 1
    
{% endif %}
