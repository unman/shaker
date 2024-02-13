include:
  - mullvad.clone

create_mullvad:
  qvm.present:
    - name: Mullvad
    - class: AppVM
    - template: template-mullvad
    - label: green

mullvad-prefs:
  qvm.prefs:
    - name: Mullvad
    - memory: 400
    - maxmem: 800
    - vcpus: 2
    - template_for_dispvms: True

mullvad-features:
  qvm.features:
    - name: Mullvad
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "start-mullvad-browser.desktop mullvad-vpn.desktop debian-xterm.desktop"
      - appmenus-dispvm: True

'qvm-appmenus --update Mullvad':
  cmd.run:
    - runas: user
