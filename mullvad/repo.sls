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

echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/mullvad.list :
  cmd.run

/usr/share/keyrings/mullvad-keyring.asc:
  file.managed:
    - source:
      - salt://mullvad/mullvad-keyring.asc
    - user: root
    - group: root
    - makedirs: True

{% if proxy == 'cacher' %}
/etc/apt/sources.list.d/mullvad.list:
  file.replace:
    - name: /etc/apt/sources.list.d/mullvad.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}

mullvad_installed:
  pkg.installed:
    - refresh: True
    - pkgs:
      - mullvad-vpn

{% endif %}
{% endif %}

{% endif %}

