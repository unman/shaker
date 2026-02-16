include:
  - salt-dev.clone

qvm-present-salt:
  qvm.present:
    - name: salt
    - template: template-salt
    - label: green

qvm-prefs-salt:
  qvm.prefs:
    - name: salt
    - netvm: tor
    - memory: 400
    - maxmem: 800
    - vcpus: 2
    - provides-network: False

qvm-features-salt:
  qvm.features:
    - name: salt
    - ipv6: ''
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy

'qvm-volume extend salt:private 22G' :
  cmd.run
