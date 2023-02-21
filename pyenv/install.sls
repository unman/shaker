# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

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

pyenv_update:
  pkg.uptodate:
    - refresh: True

pyenv_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - build-essential
      - curl
      - git
      - libbz2-dev
      - libcurl4-openssl-dev
      - libffi-dev
      - libncursesw5-dev
      - libreadline-dev
      - libsqlite3-dev
      - libssl-dev
      - libxml2-dev
      - libxmlsec1-dev
      - liblzma-dev
      - llvm
      - make
      - tk-dev
      - wget
      - xz-utils
      - zlib1g-dev
  

{% endif %}
