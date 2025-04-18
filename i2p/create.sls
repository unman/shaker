include:
  - i2p.clone

qvm-present-i2p:
  qvm.present:
    - name: sys-i2p
    - template: template-i2p
    - label: green

qvm-prefs-i2p:
  qvm.prefs:
    - name: sys-i2p
    - netvm: sys-net
    - memory: 400
    - maxmem: 1500
    - vcpus: 4
    - provides-network: False

qvm-features-i2p:
  qvm.features:
    - name: sys-i2p
    - ipv6: ''
    - disable:
      - service.clocksync
      - service.cups
      - service.cups-browsed
      - service.qubes-update-check
      - service.qubes-updates-proxy
      - service.tinyproxy
