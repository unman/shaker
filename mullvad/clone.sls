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
      - menu-items: "mullvad-vpn.desktop start-mullvad-browser.desktop debian-xterm.desktop"
      - default-menu-items: "mullvad-vpn.desktop start-mullvad-browser.desktop debian-xterm.desktop" 
