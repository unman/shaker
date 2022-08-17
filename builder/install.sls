# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if salt['qvm.exists']('cacher') %}

{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') %}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'baseurl=https://'
      - repl: 'baseurl=http://HTTPS///'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink=https://(.*)basearch'
      - repl: 'metalink=http://HTTPS///\1basearch&protocol=http'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% endfor %}
{% endif %}

install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - qubes-gpg-split
      - aspell
      - aspell-en
      - createrepo_c
      - createrepo_c-libs
      - debootstrap
      - devscripts
      - dialog
      - dpkg-dev
      - fedora-packager
      - fedora-review
      - g++
      - gcc
      - git
      - gitg
      - gnupg
      - m4
      - make
      - perl-Digest-MD5
      - perl-Digest-SHA
      - python3-pyyaml
      - python3-sh
      - re2c
      - reprepro
      - rpm-build
      - rpm-sign
      - rpmdevtools
      - systemd-container
      - texinfo
      - wget
      - vi
      - zlib-devel
