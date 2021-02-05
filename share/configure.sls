# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/rw/config/rc.local:
  file.append:
    - text: |
        systemctl unmask ssh
        systemctl start ssh

Setup:
  cmd.run:
    - name: 'mkdir /home/user/.ssh'
    - runas: user
    - creates: /home/user/.ssh 

Create_share:
  cmd.run:
    - name: |
        mkdir /home/tx
        chmod 777 /home/tx
    - runas: root
    - creates: /home/tx
