# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#

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

update_sources:
  file.replace:
    - names:
      - /etc/apt/sources.list
    - pattern: 'https:'
    - repl: 'http://HTTPS/'
    - flags: [ 'IGNORECASE', 'MULTILINE' ]
{% endif %}

base_packages:
  pkg.uptodate:
    - refresh: True

vlc.packages:
  pkg.installed:
    - pkgs:
      - vlc
      - pulseaudio-qubes

other.packages:
  pkg.installed:
    - pkgs:
      - qubes-app-shutdown-idle
      - audacious
      - calibre
      - gpicview
      - xpdf

/usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0:
  file.managed:
    - source:
      - salt://multimedia/libdvdcss.so.2.2.0
    - user: root
    - group: root

/etc/skel/.config/mimeapps.list:
  file.managed:
    - user: root
    - group: root
    - makedirs: True

mimeapps:
  file.append:
    - name: /etc/skel/.config/mimeapps.list
    - text: |
        [Default Applications]
        application/pdf=xpdf.desktop
        application/epub+zip=calibre-ebook-viewer.desktop
        application/epub=calibre-ebook-viewer.desktop
        image/avs=gpicview.desktop
        image/bie=gpicview.desktop
        image/bmp=gpicview.desktop
        image/cmyk=gpicview.desktop
        image/dcx=gpicview.desktop
        image/eps=gpicview.desktop
        image/fax=gpicview.desktop
        image/fits=gpicview.desktop
        image/g3fax=gpicview.desktop
        image/gif=gpicview.desktop
        image/gray=gpicview.desktop
        image/jpeg=gpicview.desktop
        image/miff=gpicview.desktop
        image/mono=gpicview.desktop
        image/mtv=gpicview.desktop
        image/pcd=gpicview.desktop
        image/pcx=gpicview.desktop
        image/pdf=gpicview.desktop
        image/pict=gpicview.desktop
        image/pjpeg=gpicview.desktop
        image/png=gpicview.desktop
        image/ps=gpicview.desktop
        image/rad=gpicview.desktop
        image/rgba=gpicview.desktop
        image/rla=gpicview.desktop
        image/rle=gpicview.desktop
        image/sgi=gpicview.desktop
        image/sun-raster=gpicview.desktop
        image/svg+xml=gpicview.desktop
        image/targa=gpicview.desktop
        image/tiff=gpicview.desktop
        image/uyvy=gpicview.desktop
        image/vid=gpicview.desktop
        image/viff=gpicview.desktop
        image/vnd.djvu=gpicview.desktop
        image/vnd.djvu+multipage=gpicview.desktop
        image/vnd.rn-realpix=gpicview.desktop
        image/x-bzeps=gpicview.desktop
        image/x-compressed-xcf=gpicview.desktop
        image/x-eps=gpicview.desktop
        image/x-fits=gpicview.desktop
        image/x-freehand=gpicview.desktop
        image/x-gimp-gbr=gpicview.desktop
        image/x-gimp-gih=gpicview.desktop
        image/x-gimp-pat=gpicview.desktop
        image/x-gzeps=gpicview.desktop
        image/x-icon=gpicview.desktop
        image/x-ms-bmp=gpicview.desktop
        image/x-pcx=gpicview.desktop
        image/x-portable-anymap=gpicview.desktop
        image/x-portable-bitmap=gpicview.desktop
        image/x-portable-graymap=gpicview.desktop
        image/x-portable-pixmap=gpicview.desktop
        image/x-psd=gpicview.desktop
        image/x-psp=gpicview.desktop
        image/x-rgb=gpicview.desktop
        image/x-sgi=gpicview.desktop
        image/x-tga=gpicview.desktop
        image/x-wmf=gpicview.desktop
        image/x-xbitmap=gpicview.desktop
        image/x-xcf=gpicview.desktop
        image/x-xcursor=gpicview.desktop
        image/x-xpixmap=gpicview.desktop
        image/x-xwindowdump=gpicview.desktop
        image/yuv=gpicview.desktop

ln -s /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 /usr/lib/x86_64-linux-gnu/libdvdcss.so:
  cmd.run

ln -s /usr/lib/x86_64-linux-gnu/libdvdcss.so.2.2.0 /usr/lib/x86_64-linux-gnu/libdvdcss.so.2:
  cmd.run

apt-get clean:
  cmd.run

trim_idleness:
  file.replace:
    - name: /lib/python3/dist-packages/qubesidle/idleness_monitor.py
    - pattern: '15 \* 60'
    - repl: '3 * 60'
