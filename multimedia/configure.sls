# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

/rw/config/DisposableOpen.desktop:
  file.managed:
    - source:
      - salt://multimedia/DisposableOpen.desktop

/home/user/.local/share/applications/defaults.list:
  file.managed:
    - source:
      - salt://multimedia/mimeapps.list
    - makedirs: True
    - user: user
    - group: user

/rw/config/rc.local:
  file.append:
    - text:
        - 'cp /rw/config/DisposableOpen.desktop /usr/share/applications/'
