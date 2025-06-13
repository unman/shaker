include:
  - template-debian-12-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: template-debian-12-minimal 
    - name: template-share
    - source: debian-12-minimal
