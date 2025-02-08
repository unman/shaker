# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] == 'dom0' %}

mirage-firewall-remove-old:
  file.absent:
    - names:
      - /var/lib/qubes/vm-kernels/mirage-firewall/modules.img
      - /var/lib/qubes/vm-kernels/mirage-firewall/initramfs

{% endif %}
