include:
  - build.template-fedora-34-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: build.template-fedora-34-minimal 
    - name: template-builder
    - source: fedora-34-minimal
