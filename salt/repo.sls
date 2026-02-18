# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}
{% if grains['os_family']|lower == 'debian' %}
{% if grains['nodename']|lower != 'host' %}

salt-archive-keyring:
  file.managed:
    - name: /etc/apt/keyrings/salt-archive-keyring.pgp
    - source:
      - salt://salt/salt-archive-keyring.pgp
    - user: root
    - group: root
    - makedirs: True

salt-sources:
  file.managed:
    - name: /etc/apt/sources.list.d/salt.sources
    - source:
      - salt://salt/salt.sources
    - user: root
    - group: root
    - makedirs: True

{% endif %}
{% endif %}
{% endif %}
