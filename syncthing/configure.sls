/rw/config/rc.local:
  file.append:
    - text: |
        systemctl unmask syncthing@user.service
        systemctl start  syncthing@user.service

