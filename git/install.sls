# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

/etc/qubes-rpc/qubes.Git:
  file.managed:
    - source:
      - salt://git/qubes.Git
    - user: root
    - group: root
    - mode: 755

/rw/bind-dirs/etc/qubes-rpc/qubes.Git:
  file.managed:
    - source:
      - salt://git/qubes.Git
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.append:
    - text: binds+=( '/etc/qubes-rpc/qubes.Git' )
    - makedirs: True

/home/user/repos:
  file.directory:
    - user: user
    - group: user
    - mode: 755
  
{% endif %}
