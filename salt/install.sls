# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}
include:
  - salt.repo

{% if salt['pillar.get']('update_proxy:caching') %}
{% set proxy = 'cacher' %}
{% endif %}


{% if grains['os_family']|lower == 'debian' %}
{% if grains['nodename']|lower != 'host' %}

{% if proxy  == 'cacher' %}
# broadcom.com does not support caching, so we cannot use cacher.
# Do not rewrite sources files.
# Revert sources in files from cloned template
# Ensure updates policy is set for this template.
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
salt_{{ repo }}_baseurl:
  file.replace:
    - name: {{ repo }}
    - pattern: 'http://HTTPS///'
    - repl: 'https://'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False
{% endfor %}
salt_sources_list:
  file.replace:
    - name: /etc/apt/sources.list
    - pattern: 'http://HTTPS///'
    - repl: 'https://'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}
salt_qubes_master_service:
  file.managed:
    - name: /usr/lib/systemd/system/salt-master.service.d/30_qubes.conf
    - makedirs: True
    - contents:
      - "[Unit]"
      - "ConditionPathExists=/var/run/qubes-service/salt-master"

salt_qubes_minion_service:
  file.managed:
    - name: /usr/lib/systemd/system/salt-minion.service.d/30_qubes.conf
    - makedirs: True
    - contents:
      - "[Unit]"
      - "ConditionPathExists=/var/run/qubes-service/salt-minion"

salt_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - salt-master
      - salt-minion

salt_bind_dirs:
  file.managed:
    - name: /etc/qubes-bind-dirs.d/50_user.conf
    - makedirs: True
    - contents:
      - "binds+=( /etc/salt/ )"

salt_test:
  test.nop:
    - user: {{ grains.username }}

{% endif %}
{% endif %}
{% endif %}
