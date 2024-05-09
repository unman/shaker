include:
  - gpg.clone

gpg-present-id:
  qvm.present:
    - name: sys-gpg
    - template: template-gpg
    - label: gray

gpg-prefs-id:
  qvm.prefs:
    - name: sys-gpg
    - netvm: none
    - memory: 400
    - maxmem: 800
    - vcpus: 2

gpg-features-id:
  qvm.features:
    - name: sys-gpg
    - disable:
      - service.cups
      - service.cups-browsed

'qvm-volume extend sys-gpg:private 10G' :
  cmd.run

check_gpg_policy_file:
  file.managed:
    - name: /etc/qubes/policy.d/50-config-splitgpg.policy

update_gpg_policy_file:
  file.replace:
    - name: /etc/qubes/policy.d/50-config-splitgpg.policy
    - pattern: |
        # Any changes made manually may be overwritten by Qubes Configuration Tools.
    - repl: | 
        # Any changes made manually may be overwritten by Qubes Configuration Tools.
        qubes.Gpg  *  @anyvm  sys-gpg ask 
    - count: 1
    - prepend_if_not_found: True
