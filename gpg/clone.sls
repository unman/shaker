include:
  - template-debian-10-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: template-debian-10-minimal 
    - name: template-gpg
    - source: debian-10-minimal

'sudo qubes-dom0-update qubes-gpg-split-dom0':
  cmd.run
