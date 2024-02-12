# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

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
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endif %}

installed:
  pkg.installed:
    - pkgs:
      - openssh-server
      - socat

disable:
  cmd.run:
    - name: |
        systemctl stop ssh
        systemctl disable ssh
        systemctl mask ssh

/etc/qubes-rpc/qubes.ssh:
  file.append:
    - text: |
        #!/bin/sh
        exec socat STDIO TCP:localhost:22
