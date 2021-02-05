# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/rw/config/rc.local:
  file.append:
    - text: |
        systemctl enable qubes-ssh-forwarder.socket
        systemctl start qubes-ssh-forwarder.socket
        sshfs -p 840 localhost:/home/tx tx

mkdir /home/user/tx:
  cmd.run:
    - runas: user
    - creates: /home/user/tx 

Setup:
  cmd.run:
    - names: 
        - 'mkdir /home/user/.ssh'
        - 'chmod 700 /home/user/.ssh'
    - runas: user
    - creates: /home/user/.ssh 

/rw/bind-dirs/lib/systemd/system/qubes-ssh-forwarder@.service:
  file.managed:
    - source:
      - salt://share/qubes-ssh-forwarder@.service
    - makedirs: True

/rw/bind-dirs/lib/systemd/system/qubes-ssh-forwarder.socket:
  file.managed:
    - source:
      - salt://share/qubes-ssh-forwarder.socket
    - makedirs: True

/rw/config/qubes-bind-dirs.d/50_user.conf:
  file.append:
    - text: |
        binds+=( '/lib/systemd/system/qubes-ssh-forwarder.socket')
        binds+=( '/lib/systemd/system/qubes-ssh-forwarder@.service')
    - makedirs: True
