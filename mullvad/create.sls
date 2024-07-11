include:
  - mullvad.clone

qvm-present-id:
  qvm.present:
    - name: sys-mullvad
    - class: AppVM
    - template: template-mullvad
    - label: green

qvm-prefs-id:
  qvm.prefs:
    - name: sys-mullvad
    - memory: 400
    - maxmem: 4000
    - vcpus: 2
    - provides-network: True

qvm-features-id:
  qvm.features:
    - name: sys-mullvad
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "mullvad-vpn.desktop mullvad-browser.desktop debian-xterm.desktop"
