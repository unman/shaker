monitor_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-monitor:
  qvm.clone:
    - name: template-monitor
    - source: debian-13-minimal

qvm-features-template-monitor:
  qvm.features:
    - name: template-monitor
    - set:
      - menu-items: "org.wireshark.Wireshark.desktop debian-uxterm.desktop"
      - default-menu-items: "org.wireshark.Wireshark.desktop debian-uxterm.desktop"

