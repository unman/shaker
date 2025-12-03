include:
  - qubes-doc.clone

qubes-doc-present-id:
  qvm.present:
    - name: qubes-doc
    - template: template-qubes-doc
    - label: gray

qubes-doc-prefs-id:
  qvm.prefs:
    - name: qubes-doc
    - memory: 800
    - maxmem: 8000
    - vcpus: 4

qubes-doc-features-id:
  qvm.features:
    - name: qubes-doc
    - disable:
      - service.cups

'qvm-volume extend qubes-doc:private 50G' :
  cmd.run

qubes-doc_update_policy_file:
  file.blockreplace:
    - name: /etc/qubes/policy.d/30-user-splitgpg.policy
    - marker_start: '# Start zone for qubes-doc'
    - marker_end: '# End zone for qubes-doc'
    - content: |
        qubes.Gpg	*	qubes-doc	@default	allow target=sys-gpg
        qubes.Gpg	*	qubes-doc	sys-gpg	  allow
    - append_if_not_found: True
