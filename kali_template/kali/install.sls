# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

resize2fs /dev/xvda3:
  cmd.run:
    - runas: root

{% if salt['pillar.get']('update_proxy:caching') %}
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

comment_qubes_repo:
  file.replace:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - pattern: '^deb'
    - repl: '#deb'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

kali_upgrade:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

kali_repo:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://kali/kali.list

kali_key:
  file.managed:
    - name: /usr/share/keyrings/kali-archive-key.gpg
    - source: salt://kali/kali-archive-key.gpg

3isec_qubes_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/3isec.list
    - source: salt://kali/3isec.list

3isec_qubes_key:
  file.managed:
    - name: /usr/share/keyrings/unman-keyring.gpg
    - source: salt://kali/unman-keyring.gpg

{% if salt['pillar.get']('update_proxy:caching') %}
change_/etc/apt/sources.list:
  file.replace:
    - name: /etc/apt/sources.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False

change_3isec_qubes_repo:
  file.replace:
    - name: /etc/apt/sources.list.d/3isec.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
    - backup: False
{% endif %}

kali_upgrade_again:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

kali_installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - kali-linux-core
