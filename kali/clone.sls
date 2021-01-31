include:
  - template-debian-10-minimal

qvm-clone-id:
  qvm.clone:
    - require:
      - sls: template-debian-10-minimal 
    - name: template-kali
    - source: template-debian-10-minimal

'qvm-volume extend template-kali:root 60G' :
  cmd.run

