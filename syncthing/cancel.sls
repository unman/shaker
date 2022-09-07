/rw/config/rc.local:
  file.replace:
    - pattern: 'systemctl.*unmask.*syncthing@user.service'
    - repl - ''
    - backup: False

/rw/config/rc.local_2:
  file.replace:
    - pattern: 'systemctl.*start.*syncthing@user.service''
    - repl - ''
    - backup: False

