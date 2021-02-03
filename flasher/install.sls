# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

/etc/apt/sources.list:
  file.replace:
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

/etc/apt/sources.list.d/qubes-r4.list:
  file.replace:
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

allow-testing:
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: false

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-gpg-split
      - qubes-usb-proxy
      - automake-1.15
      - autopoint
      - bc
      - bison
      - build-essential
      - curl
      - fcode-utils
      - flashrom
      - flex
      - genisoimage
      - gettext
      - git
      - gitg
      - gnat
      - gnupg
      - grub-common
      - libelf-dev
      - libfreetype6
      - libfreetype6-dev
      - libncurses-dev
      - libpci-dev
      - libssl-dev
      - libusb-1.0-0-dev
      - m4
      - mtools
      - pkg-config
      - qt5-qmake
      - unifont
      - wget
      - zlib1g-dev
