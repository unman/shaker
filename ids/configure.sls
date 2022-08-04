# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

/rw/bind-dirs/etc/snort:
  file.copy:
    - source: /etc/snort
    - makedirs: True
    - preserve: True
    - subdir: True

/usr/local/bin/monitor.sh:
  file.managed:
    - source:
      - salt://ids/monitor.sh
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/rw/config/snort.service:
  file.managed:
    - source:
      - salt://ids/snort.service
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.managed:
    - source:
      - salt://ids/50_user.conf
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/snort/snort.conf:
  file.managed:
    - source:
      - salt://ids/snort.conf
    - user: root
    - group: root
    - mode: 744
    - makedirs: True

/etc/snort/snort.debian.conf:
  file.managed:
    - source:
      - salt://ids/snort.debian.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/rw/config/rc.local:
  file.managed:
    - source:
      - salt://ids/rc.local
    - user: root
    - group: root
    - mode: 755
    - makedirs: Tr

{% endif %}
