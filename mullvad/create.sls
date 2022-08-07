include:
  - mullvad.clone

qvm-present-id:
  qvm.present:
    - name: MullvadVPN
    - class: AppVM
    - template: template-mullvad
    - label: green

qvm-prefs-id:
  qvm.prefs:
    - name: MullvadVPN
    - memory: 400
    - maxmem: 800
    - vcpus: 2
    - provides-network: true

qvm-features-id:
  qvm.features:
    - name: MullvadVPN
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
