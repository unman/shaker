# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

/usr/share/keyrings/syncthing-archive-keyring.gpg:
  file.managed:
    - source:
      - salt://syncthing/syncthing-archive-keyring.gpg
    - user: root
    - group: root
    - makedirs: True

/etc/apt/sources.list.d/syncthing.list:
  file.managed:
    - source:
      - salt://syncthing/syncthing.list
    - user: root
    - group: root
    - makedirs: True

syncthing:
  pkg.uptodate:
    - refresh: True

installed:
  pkg.installed:
    - pkgs:
      - firefox-esr
      - syncthing
      - qubes-core-agent-networking

{% endif %}
