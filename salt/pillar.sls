# Create pillar for salt-master
/srv/pillar/salt-test/init.sls:
  file.managed:
    - makedirs: True
    - source: salt://salt/pillar_init.sls
    - user: root
    - group: root
    - mode: 644

/srv/pillar/salt-test/init.top:
  file.managed:
    - makedirs: True
    - source: salt://salt/pillar_init.top
    - user: root
    - group: root
    - mode: 644

/srv/pillar/_tops/base/salt-test.top:
  file.symlink:
    - target: /srv/pillar/salt-test/init.top

