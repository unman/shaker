# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#
{% if grains['nodename'] != 'dom0' %}

/usr/share/keyrings/syncthing-archive-keyring.gpg:
  file.managed:
    - source:
      - salt://syncthing/syncthing-archive-keyring.gpg
    - user: root
    - group: root
    - makedirs: True

/etc/apt/sources.list.d/syncthing.list:
  file.managed:
    - source:
      - salt://syncthing/syncthing.list
    - user: root
    - group: root
    - makedirs: True


{% if salt['pillar.get']('update_proxy:caching') %}

{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
{{ repo }}_baseurl:
  file.replace:
    - name: {{ repo }}
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False
{% endfor %}

syncthing_repo:
  file.replace:
    - name: /etc/apt/sources.list.d/syncthing.list
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

/etc/apt/sources.list:
  file.replace:
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}

syncthing:
  pkg.uptodate:
    - refresh: True

installed:
  pkg.installed:
    - pkgs:
      - firefox-esr
      - syncthing
      - qubes-core-agent-networking

/etc/qubes-rpc/qubes.Syncthing:
  file.managed:
    - source:
      - salt://syncthing/qubes.Syncthing
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/lib/systemd/system/qubes-syncthing.service:
  file.managed:
    - source:
      - salt://syncthing/qubes-syncthing.service
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

systemctl mask syncthing@user.service:
  cmd.run

systemctl enable qubes-syncthing.service:
  cmd.run

{% endif %}
