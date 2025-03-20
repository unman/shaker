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

installed_dnscrypt:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking

dnscrypt_extract:
  archive.extracted:
    - name: /etc/skel/
    - source: salt://dnscrypt/dnscrypt-proxy-linux_x86_64-2.1.7.tar.gz
    - user: user
    - group: user

/etc/resolv.conf.backup:
  file.copy:
    - source: /etc/resolv.conf

remove_resolv.conf:
  file.absent:
    - name: /etc/resolv.conf

new_resolv.conf:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://dnscrypt/resolv.conf


{% endif %}
{% endif %}
{% endif %}
