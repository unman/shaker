# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] != 'dom0' %}
new_resolv.conf:
  file.managed:
    - name: /rw/config/resolv.conf
    - source: salt://dnscrypt/resolv.conf

dnscrypt_update_rc.local:
  file.append:
    - name: /rw/config/rc.local
    - text: |
        cp /etc/resolv.conf /etc/resolv.conf.backup
        cp /rw/config/resolv.conf /etc/resolv.conf
  

{% endif %}
