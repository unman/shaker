i2p_precursor:
  qvm.template_installed:
    - name: debian-11-minimal

qvm-clone-i2p:
  qvm.clone:
    - name: template-i2p
    - source: debian-11-minimal
