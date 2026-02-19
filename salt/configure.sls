# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{%- set MASTER_IP = salt['pillar.get']('salt-test:salt-master:ip') -%}
{%- set MINION_IP = salt['pillar.get']('salt-test:minion:ip') -%}

{% if grains['nodename'] == 'salt-master' %}
salt_master_set_firewall:
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text:
        - "nft add rule qubes custom-input ip saddr {{ MINION_IP }} tcp dport 4505-4506 accept"

{% elif grains['nodename'] == 'minion' %}
salt_minion_set_hosts:
  file.append:
    - name: /rw/config/rc.local
    - text:
        - "echo {{ MASTER_IP }}   salt  >> /etc/hosts "

{% endif %}
