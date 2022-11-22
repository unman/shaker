# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

/etc/apt-cacher-ng/acng.conf:
  file.managed:
    - source:
      - salt://cacher/acng.conf
    - user: root
    - group: root
    - makedirs: True

{% endif %}
