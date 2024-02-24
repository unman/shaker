include:
  - proton.install_repo

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

set_locale:
  cmd.run:
    - name: |
        sed -i s/# en_US.UTF-8/en_US.UTF-8/ /etc/locale.gen
        locale-gen

proton_install:
  pkg.installed:
    - refresh: True
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-network-manager
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - firefox-esr
      - network-manager
      - netcat-openbsd
      - protonvpn
      - openssh-client
      - thunderbird-qubes
      - wget
