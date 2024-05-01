store_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

store_clone:
  qvm.clone:
    - name: template-store
    - source: debian-12-minimal

store_menu:
  qvm.features:
    - name: template-store
    - set:
      - menu-items: "thunar.desktop debian-xterm.desktop"
      - default-menu-items: "thunar.desktop debian-xterm.desktop"
