mullvad_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

mullvad_clone:
  qvm.clone:
    - name: template-mullvad
    - source: debian-12-minimal

mullvad_menu:
  qvm.features:
    - name: template-mullvad
    - set:
      - menu-items: "start-mullvad-browser.desktop mullvad-vpn.desktop debian-xterm.desktop"
      - default-menu-items: "start-mullvad-browser.desktop mullvad-vpn.desktop debian-xterm.desktop" 


