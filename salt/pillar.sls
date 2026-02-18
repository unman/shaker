# Create pillar for salt-master
/srv/pillar/salt-master/init.sls:
  file.managed:
    - makedirs: True
    - source: salt://salt/pillar_init.sls
    - user: root
    - group: root
    - mode: 644

/srv/pillar/salt-master/init.top:
  file.managed:
    - makedirs: True
    - source: salt://salt/pillar_init.top
    - user: root
    - group: root
    - mode: 644

/srv/pillar/_tops/base/salt-master.top:
  file.symlink:
    - target: /srv/pillar/salt-master/init.top

