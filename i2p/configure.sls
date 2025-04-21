# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

i2p.local:
    file.append:
      - name: /rw/config/rc.local
      - text: |
          systemctl unmask i2p
          systemctl start i2p

{% endif %}
