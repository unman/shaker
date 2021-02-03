include:
  - build.template-fedora-32-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: build.template-fedora-32-minimal 
    - name: template-builder
    - source: fedora-32-minimal
