kali_requisite:
  qvm.template_installed:
    - name: debian-14-minimal

qvm-clone-kali-id:
  qvm.clone:
    - name: template-kali
    - source: debian-14-minimal

'qvm-volume extend template-kali:root 60G' :
  cmd.run
