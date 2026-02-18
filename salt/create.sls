include:
  - salt.clone

{% set targets = ['salt-master','minion']%}
{% for target in targets %}

{%- if target == 'minion' -%}
{% set netvm = 'salt-master' %}
{%- elif target == 'salt-master' -%}
{% set netvm = 'none' %}
{% endif %}



qvm-present-{{ target }}-salt:
  qvm.present:
    - name: {{ target }}
    - template: template-salt
    - label: green

qvm-prefs-{{ target }}-salt:
  qvm.prefs:
    - name: {{ target }}
    - maxmem: 800
    - memory: 400
    - netvm: {{ netvm }}
    - provides_network: True 
    - vcpus: 2

qvm-features-{{ target }}-salt:
  qvm.features:
    - name: {{ target }}
    - ipv6: ''
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy

qvm-volume extend {{ target }}:private 10G :
  cmd.run

{% endfor %}

{% if salt['pillar.get']('update_proxy:caching') %}
{% set proxy = 'cacher' %}
{% endif %}

{% if proxy  == 'cacher' %}
# Ensure updates policy is set for this template.
salt_set_updates_proxy:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-updates.policy
    - header: True
    - text:
      - "qubes.UpdatesProxy  *  template-salt  @default  allow target=sys-net"
{% endif %}
