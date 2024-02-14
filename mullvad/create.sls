include:
  - mullvad.clone

qvm-present-id:
  qvm.present:
    - name: mullvad
    - class: AppVM
    - template: template-mullvad
    - label: green

qvm-prefs-id:
  qvm.prefs:
    - name: mullvad
    - memory: 400
    - maxmem: 800
    - vcpus: 2

qvm-features-id:
  qvm.features:
    - name: mullvad
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "start-mullvad-browser.desktop mullvad-vpn.desktop debian-xterm.desktop"
