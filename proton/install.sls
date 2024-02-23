include:
  - proton.clone

/tmp/protonvpn-stable-release_1.0.3-2_all.deb:
  file.managed:
    - source:
      - salt://proton/protonvpn-stable-release_1.0.3-2_all.deb

'dpkg -i /tmp/protonvpn-stable-release_1.0.3-2_all.deb':
  cmd.run

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
{% endif %}
{% endif %}
{% endif %}

proton_install:
  pkg.installed:
    - skip_suggestions: True
    - install_recommends: False
    - pkgs:
      - qubes-core-agent-network-manager
      - qubes-core-agent-networking
      - firefox-esr
      - network-manager
      - protonvpn-gui
