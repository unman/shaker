# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] != 'dom0' %}

include:
  - cacher.mirrors

allow-testing:
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: false

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - anacron 
      - apt-cacher-ng 

disable-tinyproxy:
  cmd.run:
    - name: systemctl disable tinyproxy

mask-tinyproxy:
  cmd.run:
    - name: systemctl mask tinyproxy

disable-qubes-proxy:
  cmd.run:
    - name: systemctl disable qubes-updates-proxy

mask-qubes-proxy:
  cmd.run:
    - name: systemctl mask qubes-updates-proxy

disable-apt-cacher:
  cmd.run:
    - name: systemctl disable apt-cacher-ng

mask-apt-cacher:
  cmd.run:
    - name: systemctl mask apt-cacher-ng

/etc/apt-cacher-ng/backends_debian:
  file.prepend:
    - text: https://deb.debian.org/debian

/etc/apt-cacher-ng/acng.conf:
  file.managed:
    - source:
      - salt://cacher/acng.conf
    - user: root
    - group: root
    - makedirs: True

cp /lib/apt-cacher-ng/deb_mirrors.gz /etc/apt-cacher-ng/deb_mirrors.gz:
  cmd.run:
    - runas: root

/usr/lib/qubes-bind-dirs.d/30_cron.conf:
  file.append:
    - text: "binds+=( ' /etc/anacrontab' )"

{% endif %}
