/home/user/.gitconfig:
  file.managed:
    - source:
      - salt://qubes-builder/builder-gitconfig
    - user: user
    - group: user

/rw/config/gpg-split-domain:
  file.managed:
    - source:
      - salt://qubes-builder/builder-split-gpg-config
    - user: root
    - group: root

/home/user/.rpmmacros:
  file.managed:
    - source:
      - salt://qubes-builder/rpmmacros
    - user: user
    - group: user

https://github.com/QubesOS/qubes-builder.git:
  git.cloned:
    - name: https://github.com/QubesOS/qubes-builderv2.git
    - target: /home/user/qubes-builderv2
    - user: user

setup_mkmetalink:
  git.latest:
    - name: https://github.com/QubesOS/qubes-infrastructure-mirrors.git
    - target: /home/user/qubes-infrastructure-mirrors
    - user: user

build_infrastructure:
  cmd.run:
    - name: python3 setup.py build
    - cwd: /home/user/qubes-infrastructure-mirrors
    - runas: root

install_infrastructure:
  cmd.run:
    - name: python3 setup.py install
    - cwd: /home/user/qubes-infrastructure-mirrors
    - runas: root
