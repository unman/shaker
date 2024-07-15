/home/user/.gitconfig:
  file.managed:
    - source:
      - salt://qubes-doc/doc-gitconfig
    - user: user
    - group: user

/rw/config/gpg-split-domain:
  file.managed:
    - source:
      - salt://qubes-doc/split-gpg-config
    - user: root
    - group: root

https://github.com/QubesOS/qubesos.github.io.git:
  git.latest:
    - name: https://github.com/QubesOS/qubesos.github.io.git
    - target: /home/user/qubesos.github.io
    - user: user
    - submodules: True

'gem update --system':
  cmd.run:
    - user: root

'gem install jekyll bundler':
  cmd.run:
    - user: user

'gem install sass --force':
  cmd.run:
    - user: user

'gem install github-pages':
  cmd.run:
    - user: user

add_webrick:
  file.append:
    - name: /home/user/qubesos.github.io/Gemfile
    - text: 'gem: webrick'
