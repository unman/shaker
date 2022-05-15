# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#
{% if grains['os_family']|lower == 'debian' %}
  /etc/apt/sources.list:
    file.replace:
      - names: 
        - /etc/apt/sources.list
        - /etc/apt/sources.list.d/qubes-r4.list
      - pattern: 'https:'
      - repl: 'http://HTTPS/'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% elif grains['os_family']|lower == 'arch' %}
  pacman:
    file.replace:
      - names:
        - /etc/pacman.d/mirrorlist
        - /etc/pacman.d/99-qubes-repository-4.1.conf.disabled
      - pattern: 'https:'
      - repl: 'http://HTTPS/'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]

{% elif grains['os_family']|lower == 'redhat' %}
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
