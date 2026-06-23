i2p_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-i2p:
  qvm.clone:
    - name: template-i2p
    - source: debian-13-minimal
