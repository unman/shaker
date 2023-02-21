# Create pillar for proxy
/srv/pillar/update_proxy/init.sls:
  file.managed:
    - makedirs: True
    - source: salt://cacher/pillar_init.sls
    - user: root
    - group: root
    - mode: 644

/srv/pillar/update_proxy/init.top:
  file.managed:
    - makedirs: True
    - source: salt://cacher/pillar_init.top
    - user: root
    - group: root
    - mode: 644

/srv/pillar/_tops/base/update_proxy.top:
  file.symlink:
    - target: /srv/pillar/update_proxy/init.top

