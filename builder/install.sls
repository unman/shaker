# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if salt['qvm.exists']('cacher') %}

/etc/yum.repos.d/:
  file.replace:
    - names:
      - /etc/yum.repos.d/fedora.repo
      - /etc/yum.repos.d/fedora-updates.repo
      - /etc/yum.repos.d/fedora-updates-testing.repo
      - /etc/yum.repos.d/fedora-cisco-openh264.repo
    - pattern: 'metalink=https://(.*)basearch'
    - repl: 'metalink=http://HTTPS///\1basearch&protocol=http'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

/etc/yum.repos.d/qubes-r4.repo:
    file.replace:
      - pattern: 'https://'
      - repl: 'http://HTTPS///'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

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
      - zlib-devel
