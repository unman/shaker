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
    - maxmem: 800
    - vcpus: 2
    - provides_network: True

qvm-features-id:
  qvm.features:
    - name: sys-mullvad
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "start-mullvad-browser.desktop mullvad-vpn.desktop debian-xterm.desktop"
