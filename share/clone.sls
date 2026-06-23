include:
  - template-debian-13-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: template-debian-13-minimal 
    - name: template-share
    - source: debian-13-minimal
