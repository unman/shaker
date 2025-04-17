i2p_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

qvm-clone-i2p:
  qvm.clone:
    - name: template-i2p
    - source: debian-12-minimal
