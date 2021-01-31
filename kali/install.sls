# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

resize2fs /dev/xvda3:
  cmd.run:
    - runas: root
  
/etc/apt/sources.list.replace:
  file.replace:
    - name: '/etc/apt/sources.list'
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

uptodate:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

/etc/apt/sources.list.update:
  file.replace:
    - name: '/etc/apt/sources.list'
    - pattern: 'buster'
    - repl: 'bullseye'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

/etc/apt/sources.list.security:
  file.replace:
    - name: '/etc/apt/sources.list'
    - pattern: 'bullseye/updates'
    - repl: 'bullseye-security'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

/etc/apt/sources.list.d/qubes-r4.list.update:
  file.replace:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'buster'
    - repl: 'bullseye'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]

upgrade:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

python3-apt:
  pkg.installed:
    - refresh: True

kali:
  pkgrepo.managed:
    - humanname: Kali repository
    - name: deb http://HTTPS///http.kali.org/kali kali-rolling main contrib non-free
    - file: /etc/apt/sources.list.d/kali.list
    - key_url: salt://kali/kali.key

upgrade_again:
  pkg.uptodate:
    - refresh: True
    - dist_upgrade: True

installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - kali-linux-default
      - kali-desktop-kde
