# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

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

vlc.packages:
  pkg.installed:
    - pkgs:
      - vlc
      - pulseaudio-qubes

/usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0:
  file.managed:
    - source:
      - salt://multimedia/libdvdcss.so.2.2.0
    - user: root
    - group: root

ln -s /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 /usr/lib/x86_64-linux-gnu/libdvdcss.so:
  cmd.run

ln -s /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 /usr/lib/x86_64-linux-gnu/libdvdcss.so.2:
  cmd.run

apt-get clean:
  cmd.run
