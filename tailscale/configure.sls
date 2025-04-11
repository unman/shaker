# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}

tailscale_rc.local:
    file.append:
      - name: /rw/config/rc.local
      - text: |
          systemctl unmask tailscaled
          systemctl start tailscaled
          tailscale up

tailscale_binds:
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50_user.conf
    - source:
      - salt://tailscale/50_user.conf
    - user: root
    - group: root
    - makedirs: True

{% endif %}
