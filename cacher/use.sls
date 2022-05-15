qvm-present-id:
  qvm.present:
    - name: cacher
    - template: template-cacher
    - label: gray

/etc/qubes/policy.d/30-user.policy:
  file.prepend:
    - text: "qubes.UpdatesProxy  *  @type:TemplateVM  @default  allow target=cacher"
