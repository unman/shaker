# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#

{% if grains['nodename'] != 'dom0' %}

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

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endif %}

update:
  pkg.uptodate:
    - refresh: True

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-app-shutdown-idle
      - qubes-gpg-split
      - mb2md
      - mutt
      - notmuch
      - notmuch-mutt
      - offlineimap3
      - openssh-client
      - rsync
      - w3m
      - zenity
    - skip_suggestions: True
    - install_recommends: False

change_timeout:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesidle/idleness_monitor.py
    - pattern: '15 * 60'
    - repl: '3 * 60'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

default_muttrc:
  file.managed:
    - name: /etc/skel/.muttrc
    - source: salt://3isec-common/mutt/muttrc
    - user: user
    - group: user

helper_script:
  file.managed:
    - name: /etc/skel/setup_mutt.sh
    - source: salt://3isec-common/mutt/setup_mutt.sh
    - user: user
    - group: user
    - mode: 744

helper_script_menu:
  file.managed:
    - name: /usr/share/applications/mutt_setup.desktop
    - source: salt://3isec-common/mutt/mutt_setup.desktop
    - user: user
    - group: user
    - mode: 755

{% endif %}
