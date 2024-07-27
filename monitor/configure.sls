# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

/rw/config/rc.local:
  file.append:
    - text: systemctl unmask suricata

# Make settings persistent using bind-dirs
bind_suricata_logs:
  file.append:
    - name: /rw/config/qubes-bind-dirs.d/50_user.conf
    - text: "binds+=( '/var/log/suricata/' )"
    - makedirs: True

{% endif %}
