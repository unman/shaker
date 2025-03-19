qvm-present-dnscrypt:
  qvm.present:
    - name: sys-dnscrypt
    - template: template-dnscrypt
    - label: green

qvm-prefs-dnscrypt:
  qvm.prefs:
    - name: sys-dnscrypt
    - netvm: sys-net
    - memory: 400
    - maxmem: 1500
    - vcpus: 2
    - provides-network: True

qvm-features-dnscrypt:
  qvm.features:
    - name: sys-dnscrypt
    - ipv6: ''
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
