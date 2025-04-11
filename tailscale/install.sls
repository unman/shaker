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

requirements_installed:
  pkg.installed:
    - refresh: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - iproute2
      - libnotify-bin
      - lsb-release
      - xz-utils

/etc/apt/sources.list.d/tailscale.list:
  file.managed:
    - source:
      - salt://tailscale/tailscale.list
    - user: root
    - group: root
    - makedirs: True

/usr/share/keyrings/tailscale-archive-keyring.gpg:
  file.managed:
    - source:
      - salt://tailscale/bookworm.noarmor.gpg
    - user: root
    - group: root
    - makedirs: True

{% if proxy == 'cacher' %}
use_cacher_tailscale:
  file.replace:
    - name: /etc/apt/sources.list.d/tailscale.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}

tailscale_installed:
  pkg.installed:
    - refresh: True
    - pkgs:
      - tailscale

disable_tailscaled:
  service.disabled:
    - name: tailscaled

mask_tailscaled:
  service.masked:
    - name: tailscaled
{% endif %}
{% endif %}
{% endif %}
