create_precursor:
  qvm.template_installed:
    - name: debian-12-xfce

git-present-id:
  qvm.present:
    - name: sys-git
    - template: debian-12-xfce
    - label: gray

git-prefs-id:
  qvm.prefs:
    - name: sys-git
    - netvm: none
    - memory: 400
    - maxmem: 800
    - vcpus: 2

git-features-id:
  qvm.features:
    - name: sys-git
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend sys-git:private 40G' :
  cmd.run

update_policy_file_git:
  file.prepend:
    - name: '/etc/qubes/policy.d/30-user.policy'
    - text: 'qubes.Git  *  @anyvm  @anyvm ask default_target=sys-git'
