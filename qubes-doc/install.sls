# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/etc/yum.repos.d/gh-cli.repo:
  file.managed:
    - source:
      - salt://qubes-doc/gh-cli.repo

/etc/pki/rpm-gpg/gh.asc:
  file.managed:
    - source:
      - salt://qubes-doc/gh.asc

rpm --import /etc/pki/rpm-gpg/gh.asc:
  cmd.run

{% if salt['pillar.get']('update_proxy:caching') %}

{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') %}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'baseurl.*=.*https://'
      - repl: 'baseurl=http://HTTPS///'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False
{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink.*=.*https://(.*)basearch'
      - repl: 'metalink=http://HTTPS///\1basearch&protocol=http'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% endfor %}


{% endif %}

qubes-doc_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - qubes-gpg-split
      - gh
      - gnupg2
      - podman
      - podman-compose
      - redhat-rpm-config
      - ruby
      - ruby-devel
      - zlib-ng-compat-devel
      - nodejs
