# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] == 'dom0' %}

/var/lib/qubes/vm-kernels/mirage-firewall:
  file.directory:
    - mode: 755
    - makedirs: True

mirage_extracted:
  archive.extracted:
    - name: /var/lib/qubes/vm-kernels/
    - source: salt://mirage/mirage-firewall.tar.bz2
    - source_hash: ea876bc7525811a16b0dfebe7ee1e91661eeecf67d240298d4ffd31b6ee41843
    - archive_format: tar
    - options: -j

mirage-firewall:
  qvm.present:
    - name: mirage-firewall
    - class: StandaloneVM
    - label: green
    - virt_mode: pvh
    - kernel: mirage-firewall
    - kernelopts: ''
    - mem: 32
    - vcpus: 1

mirage-firewall-prefs:
  qvm.prefs:
    - name: mirage-firewall
    - kernel: mirage-firewall
    - maxmem: 32
    - provides-network: True
    - netvm: sys-net
    - default_dispvm: ''
    - kernelopts: ''

mirage-firewall-features:
  qvm.features:
    - name: mirage-firewall
    - enable:
      - qubes-firewall
      - no-default-kernelopts


{% endif %}
