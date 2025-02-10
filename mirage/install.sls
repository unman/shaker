# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] == 'dom0' %}

/var/lib/qubes/vm-kernels/mirage-firewall:
  file.directory:
    - mode: 755
    - makedirs: True

mirage-firewall-kernel:
  file.managed:
    - name: /var/lib/qubes/vm-kernels/mirage-firewall/vmlinuz
    - source: salt://mirage/qubes-firewall.xen

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
