{% set IP = salt['cmd.run']('qvm-prefs salt-master ip') -%}
{% set MINION_IP = salt['cmd.run']('qvm-prefs minion ip') -%}

salt-test:
  salt-master:
    ip: {{ IP }}
  minion:
    ip: {{ MINION_IP }}
