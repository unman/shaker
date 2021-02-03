include:
  - flasher.clone

qvm-present-id:
  qvm.present:
    - name: flasher
    - template: template-flasher
    - label: gray

qvm-prefs-id:
  qvm.prefs:
    - name: flasher
    - netvm: tor
    - memory: 400
    - maxmem: 2000
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: flasher
    - disable:
      - service.cups
      - service.cups-browsed
