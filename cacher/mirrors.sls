# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

/etc/apt-cacher-ng/fedora_mirrors_extra:
  file.managed:
    - source:
      - salt://cacher/fedora_mirrors_extra
    - user: root
    - group: root
    - makedirs: True

/etc/apt-cacher-ng/archlx_mirrors_extra:
  file.managed:
    - source:
      - salt://cacher/archlx_mirrors_extra
    - user: root
    - group: root
    - makedirs: True

/etc/apt-cacher-ng/debian_mirrors_extra:
  file.managed:
    - source:
      - salt://cacher/debian_mirrors_extra
    - user: root
    - group: root
    - makedirs: True

{% endif %}
