# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

/rw/config/rc.local:
  file.append:
    - text: systemctl unmask suricata

{% endif %}
