include:
  - mullvad.clone
  - mullvad.create

create_mullvad_dvm:
  qvm.present:
    - name: mullvad-dvm
    - class: AppVM
    - template: template-mullvad
    - label: green

mullvad-prefs_dvm:
  qvm.prefs:
    - name: mullvad-dvm
    - memory: 400
    - maxmem: 800
    - vcpus: 2
    - template_for_dispvms: True

mullvad-features_dvm:
  qvm.features:
    - name: mullvad-dvm
    - disable:
      - service.cups
      - service.cups-browsed
      - service.tinyproxy
    - set:
      - menu-items: "mullvad-vpn.desktop start-mullvad-browser.desktop debian-xterm.desktop"
      - appmenus-dispvm: True

'qvm-appmenus --update mullvad-dvm':
  cmd.run:
    - runas: user
