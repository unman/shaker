Name:           3isec-qubes-doc
Version:        1
Release:        3%{?dist}
Summary:        Prepares qube for building Qubes web site and documentation
Requires:       3isec-qubes-common

License:        GPLv3+
SOURCE0:        qubes-doc

%description
These salt files can be used to set-up a template for building the Qubes website and documentation.
The template is a clone of the fedora-42 template.
A qubes-doc qube is created and configured to use git and split-gpg.
Helper scripts are included to aid building.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/qubes-doc/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply qubes-doc.create
  qubesctl --skip-dom0 --targets=template-qubes-doc state.apply qubes-doc.install  
  qubesctl --skip-dom0 --targets=qubes-doc state.apply qubes-doc.config
fi

%preun


%changelog
* Wed Dec 3 2025 unman <unman@thirdeyesecurity.org> 1.3
- Minor sp in build_docs
- Update spec file
* Wed Dec 3 2025 unman <unman@thirdeyesecurity.org>
- Rebase to Fedora 42 template
- Update/create user policy file for split-gpg.
- Install poetry in qubes-doc qube. 
- Supply basic helper scripts in qubes-doc.
* Mon Jul 15 2024 unman <unman@thirdeyesecurity.org>
- First Build
