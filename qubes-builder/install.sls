# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/etc/yum.repos.d/gh-cli.repo:
  file.managed:
    - source:
      - salt://qubes-builder/gh-cli.repo

/etc/pki/rpm-gpg/gh.asc:
  file.managed:
    - source:
      - salt://qubes-builder/gh.asc

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

qubes-builder_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - qubes-gpg-split
      - dnf5-plugins
      - asciidoc
      - createrepo_c
      - devscripts
      - fedpkg
      - gnupg2
      - gh
      - m4
      - mock
      - openssl
      - pacman
      - pacman-key
      - podman
      - python3-click
      - python3-docker
      - python3-jinja2-cli
      - python3-lxml
      - python3-packaging
      - python3-pathspec
      - python3-podman
      - python3-pyyaml
      - python3-setuptools
      - rb_libtorrent-examples
      - reprepro
      - rpm
      - rpm-sign
      - rsync
      - sequoia-chameleon-gnupg
      - sequoia-sq
      - sequoia-sqv
      - tree
      - neovim
      - vim-minimal
