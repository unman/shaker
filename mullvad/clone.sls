mullvad_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

mullvad_clone:
  qvm.clone:
    - name: template-mullvad
    - source: debian-13-minimal

mullvad_menu:
  qvm.features:
    - name: template-mullvad
    - set:
      - menu-items: "mullvad-vpn.desktop mullvad-browser.desktop debian-xterm.desktop"
      - default-menu-items: "mullvad-vpn.desktop mullvad-browser.desktop debian-xterm.desktop"
