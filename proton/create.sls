include:
  - proton.clone

qvm-present-id:
  qvm.present:
    - name: proton
    - class: AppVM
    - template: template-proton
    - label: green

qvm-prefs-id:
  qvm.prefs:
    - name: proton
    - memory: 400
    - maxmem: 800
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: proton
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - enable:
      - service.network-manager
    - set:
      - menu-items: "protonvpn.desktop  firefox-esr.desktop debian-xterm.desktop"
