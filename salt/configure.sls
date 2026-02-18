# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% set MASTER_IP = salt['pillar.get']('salt-master:ip') %}

{% if grains['nodename'] == 'minion' %}
salt_minion_set_hosts:
  file.append:
    - name: /rw/config/rc.local
    - text:
        - "echo {{ MASTER_IP }}   salt  >> /etc/hosts "
{% endif %}
