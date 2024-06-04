# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#
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

{% elif grains['os_family']|lower == 'arch' %}
  pacman:
    file.replace:
      - names:
        - /etc/pacman.d/mirrorlist
        - /etc/pacman.d/99-qubes-repository-4.1.conf.disabled
      - pattern: 'https:'
      - repl: 'http://HTTPS/'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% elif grains['os_family']|lower == 'redhat' %}

stop_zchunk:
  file.append:
    - name: /etc/dnf/dnf.conf
    - text: zchunk=False

{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') %}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'baseurl(.*)https://'
      - repl: 'baseurl\1http://HTTPS///'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False
{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink=https://(.*)basearch'
      - repl: 'metalink=http://HTTPS///\1basearch&protocol=http'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% endfor %}
{% for repo in salt['file.find']('/etc/yum.repos.d/', name='rpmfusion*repo*') %}
{{ repo }}_uncomment:
    file.uncomment:
      - name: {{ repo }}
      - regex : '.*baseurl(.*)'
      - backup: False
{{ repo }}_comment:
    file.comment:
      - name: {{ repo }}
      - regex: '^metalink=http(.*)'
      - ignore_missing: True
      - backup: False

{% endfor %}
{% endif %}
