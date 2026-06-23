dnscrypt_precursor:
  qvm.template_installed:
    - name: debian-13-minimal

qvm-clone-dnscrypt:
  qvm.clone:
    - name: template-dnscrypt
    - source: debian-13-minimal
