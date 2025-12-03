# Introduction
These salt files can be used to set-up a template for building the Qubes website and documentation.
The template is a clone of the fedora-42 template.
A qubes-doc qube is created and configured to use git and split-gpg.

# Installation
Copy the qubes-doc directory to /srv/salt, then run:
```
sudo qubesctl state.apply qubes-doc.create
sudo qubesctl --skip-dom0 --targets=template-qubes-doc state.apply qubes-doc.install  
sudo qubesctl --skip-dom0 --targets=qubes-doc state.apply qubes-doc.config
```

If you want to use git, a boilerplate `~.gitconfig` is included in qubes-doc.
Remember to edit this file with your details.
split-gpg is automatically configured to use sys-gpg as the backend qube holding the PGP key.
Edit the policy if you want to use a different backend qube to store your gpg key.

## Building the site
```
cd qubesos.github.io
bundle exec jekyll serve
```
You may need to edit `Gemfile` to include `gem webrick`

## Notes

`create.sls` uses *include* to call `clone.sls`. This state ensures that a fedora-42 template is installed, and will install it if not: the template is cloned to create a template for qubes-doc. The remainder of the state creates the qubes-doc qube, and creates the split-gpg policy.

`install.sls` configures qubes-doc repositories to use the caching proxy if present. (Look at the use of the *if* statement checking for the existence of the relevant pillar.)
`pkg.installed` is used to install the needed packages.

`config.sls` is applied to the new *qubes-doc* qube.
`file.managed` is used to transfer configuration files for split-gpg to the qube.
`git.latest` is used to clone the git repository - `submodules: True` is used to pull in all submodules.

There *is* a salt gem state, which could be used to install gems:  
```
qubes_doc_gems:
  gem.installed:
    - names:
      - jekyll
```
But the results are variable, and some gems cannot be installed by this method.
So we fall back to using `cmd.run` again to get gems installed.

