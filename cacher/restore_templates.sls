# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['os_family']|lower == 'debian' %}
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*list') %}
  {{ repo }}_baseurl:
      file.replace:
        - name: {{ repo }}
        - pattern: 'http://HTTPS/'
        - repl: 'https:'
        - flags: [ 'IGNORECASE', 'MULTILINE' ]
{% endfor %}

  /etc/apt/sources.list:
    file.replace:
      - name: /etc/apt/sources.list
      - pattern: 'http://HTTPS/'
      - repl: 'https:'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% elif grains['os_family']|lower == 'arch' %}
  pacman:
    file.replace:
      - names:
        - /etc/pacman.d/mirrorlist
        - /etc/pacman.d/99-qubes-repository-4.1.conf.disabled
      - pattern: 'http://HTTPS///'
      - repl: 'https://'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]


{% elif grains['os_family']|lower == 'redhat' %}
{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') %}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'http://HTTPS/'
      - repl: 'https:'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink=http://HTTPS///(.*)basearch&protocol=http'
      - repl: 'metalink=https://\1basearch'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endfor %}
{% endif %}
