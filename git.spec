Name:           3isec-qubes-git
Version:       	0.1
Release:        1%{?dist}
Summary:        Create sys-git in Qubes

License:        GPLv3+
SOURCE0:	      git

%description
This package provides a central git qube, named sys-git.
By default the qube has no netvm, but you can set one if you wish.

Some configuration is needed.
Repositories must be created under /home/user/repos in sys-git, and
repository names must be common between sys-git and client qubes.

# Setting up a new repository

## sys-git
In sys-git, repositories are stored bare under /home/user/repos
First, prepare a repository:
```
mkdir repos/X
cd repos/X
git init --bare
```

## prepare client
Then prepare a qube by running:
`qubesctl --skip0-dom0 --targets=QUBE state.apply git.install_client`

## Work in the client
Configure git, as necessary.  
Open a terminal in the qube:
```
mkdir X
cd X
git init
add-remote sg
```
You can then use that repository as usual, making commits.
To push to sys-git you must first-  
`git push --set-upstream sg master`

After making more commits,
`git push `

# Working with an existing repository

## prepare client, if necessary
Prepare a qube by running:
`qubesctl --skip0-dom0 --targets=QUBE state.apply git.install_client`

## Clone the repository in the client
Configure git, as necessary.  
Open a terminal in the qube:
```
mkdir X
cd X
git init
add-remote sg
git pull sg master
```

## Work in the client
You can then use that repository as usual.
To push to sys-git you must first-  
`git push --set-upstream sg master`

After making more commits,  
`git push `


# Access control
Access to sys-git is governed by policy rules in `/etc/qubes/policy/30-user.policy`
The default rule allows access from any qube to sys-git, after a confirmation dialog.  
`qubes.Git  *  @anyvm  @anyvm ask default_target=sys-git`

You can control access to sys-git by qube, and restrict qubes to specific named repositories:  
```
qubes.Git  +REPO  QUBE   @anyvm  ask default_target=sys-git
qubes.Git  *      QUBE2  @anyvm  ask default_target=sys-git  
qubes.Git  *      *     sys-git deny
```
These rules will allow QUBE to access the REPO repository on sys-git, but no other.
QUBE2 is allowed to access any repository on sys-git.  
No other qube is allowed access at all.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/git/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply git.create
  qubesctl --skip-dom0 --targets=sys-git state.apply monero.install
fi

%postun
if [ $1 -eq 0 ]; then
fi

%changelog
* Wed Nov 16 2022 unman <unman@thirdeyesecurity.org> - 0.1
- First Build
