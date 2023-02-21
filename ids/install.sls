# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

{% if salt['pillar.get']('update_proxy:caching') %}

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
      - /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endif %}

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - libnotify-bin
      - mate-notification-daemon
      - snort
      - oinkmaster

systemd-disable-snort:
  cmd.run:
    - name: systemctl disable snort

systemd-mask-snort:
  cmd.run:
    - name: systemctl mask snort

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
    - mode: 644
    - makedirs: True

/rw/config/monitor.service:
  file.managed:
    - source:
      - salt://ids/monitor.service
    - user: root
    - group: root
    - mode: 644
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
    - mode: 644
    - makedirs: True

/etc/snort/snort.conf:
  file.managed:
    - source:
      - salt://ids/snort.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/etc/snort/snort.debian.conf:
  file.managed:
    - source:
      - salt://ids/snort.debian.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True


{% endif %}
