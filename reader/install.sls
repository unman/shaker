# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if salt['qvm.exists']('cacher') %}
{% if grains['os_family']|lower == 'debian' %}
{% if grains['nodename']|lower != 'host' %}
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
    - name: /etc/apt/sources.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

{% endif %}
{% endif %}
{% endif %}

{% if grains['nodename'] != 'dom0' %}

allow-testing:
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: false

installed:
  pkg.installed:
    - refresh: True
    - pkgs:
      - qubes-core-agent-networking
      - antiword
      - edbrowse
      - evince
      - firefox-esr
      - libreoffice
      - mutt
      - notmuch
      - notmuch-mutt
      - notmuch-vim
      - offlineimap
      - orca
      - python3-pdfminer
      - w3m

{% endif %}

