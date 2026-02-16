# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#
{% if grains['nodename'] == 'dom0' %}
include:
  - salt-dev.create
{% endif %}

{% if grains['nodename'] == 'template-salt' %}

{% if salt['pillar.get']('update_proxy:caching') %}
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
{{ repo }}_baseurl:
  file.replace:
    - name: {{ repo }}
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endfor %}

update_sources:
  file.replace:
    - names:
      - /etc/apt/sources.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False
{% endif %}

salt_install_required_pkgs:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - firefox-esr
      - git
      - nox
      - pre-commit
      - python-is-python3
      - python3-looseversion
      - python3-myst-parser
      - python3-networkx
      - python3-pip
      - python3-sphinx
      - python3-sphinxcontrib.httpdomain
      - python3-tornado

{% endif %}

{% if grains['nodename'] == 'salt' %}

salt_clone:
  git.latest:
    - name: https://github.com/saltstack/salt.git
    - target: /home/user/salt
    - user: user
    - depth: 1
    - rev: master

'pre-commit install':
  cmd.run:
    - cwd: /home/user/salt
    - runas: user

{% endif %}
