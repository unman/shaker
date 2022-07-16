# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#

{% if salt['qvm.exists']('cacher') %}

/etc/apt/sources.list:
  file.replace:
    - names:
      - /etc/apt/sources.list
      - /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'https://'
    - repl: 'http://HTTPS///'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endif %}

{% if grains['nodename'] != 'dom0' %}
update:
  pkg.uptodate:
    - refresh: True

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - mb2md
      - mutt
      - notmuch
      - notmuch-mutt
      - openssh-client
      - qubes-app-shutdown-idle
      - rsync
      - w3m
    - skip_suggestions: True

change_timeout:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesidle/idleness_monitor.py
    - pattern: '15 * 60'
    - repl: '3 * 60'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

default_muttrc:
  file.managed:
    - name: /etc/skel/.muttrc
    - source: salt://mutt/muttrc
    - user: user
    - group: user


{% endif %}
