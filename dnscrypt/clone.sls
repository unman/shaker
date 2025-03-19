dnscrypt_precursor:
  qvm.template_installed:
    - name: debian-12-minimal

qvm-clone-dnscrypt:
  qvm.clone:
    - name: template-dnscrypt
    - source: debian-12-minimal
