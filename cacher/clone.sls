include:
  - template-debian-11-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: template-debian-11-minimal 
    - name: template-cacher
    - source: debian-11-minimal
