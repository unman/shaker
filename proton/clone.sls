proton_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

proton_clone:
  qvm.clone:
    - name: template-proton
    - source: debian-12-minimal

proton_menu:
  qvm.features:
    - name: template-proton
    - set:
      - menu-items: "protonvpn.desktop firefox-esr.desktop debian-xterm.desktop"
      - default-menu-items: "protonvpn.desktop firefox-esr.desktop debian-xterm.desktop" 
