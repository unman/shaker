include:
  - ids.clone

qvm-present-ids:
  qvm.present:
    - name: sys-ids
    - template: template-ids
    - label: green

qvm-prefs-ids:
  qvm.prefs:
    - name: sys-ids
    - netvm: sys-net
    - memory: 400
    - maxmem: 1500
    - vcpus: 2
    - provides-network: True

qvm-features-ids:
  qvm.features:
    - name: sys-ids
    - ipv6: ''
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy

'qvm-volume extend sys-ids:private 20G' :
  cmd.run

