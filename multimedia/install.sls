# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

{% if salt['qvm.exists']('cacher') %}
update_sources:
  file.replace:
    - names:
      - /etc/apt/sources.list
      - /etc/apt/sources.list.d/qubes-r4.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
{% endif %}

vlc.packages:
  pkg.installed:
    - pkgs:
      - vlc
      - pulseaudio-qubes

other.packages:
  pkg.installed:
    - pkgs:
      - audacious
      - calibre

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
