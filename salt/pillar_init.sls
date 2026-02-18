{% set IP = salt['cmd.run']('qvm-prefs salt-master ip') -%}

salt-master:
  ip: {{ IP }}
