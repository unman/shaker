Name:           3isec-qubes-doc
Version:        1
Release:        1%{?dist}
Summary:        Prepares qube for building Qubes web site and documentation
Requires:       3isec-qubes-common

License:        GPLv3+
SOURCE0:        qubes-doc

%description
These salt files can be used to set-up a template for building the Qubes website and documentation.
The template is a clone of the fedora-40 template.
A qubes-doc qube is created and configured to use git and split-gpg.

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
* Mon Jul 15 2024 unman <unman@thirdeyesecurity.org>
- First Build
