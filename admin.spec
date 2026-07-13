Name:           3isec-qubes-admin
Version:        1
Release:        2%{?dist}
Summary:        Prepares an admin qube for use in Qubes

License:        GPLv3+
SOURCE0:        admin

%description
This package creates a template cloned from debian-13-minimal which can
be used as the basis for admin qubes. A default sys-admin is created.
A policy file is created which allows sys-admin to control only qubes
created by it - the file contains a commented section for extending
administration to all qubes.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/admin/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply admin.create
  qubesctl --skip-dom0 --targets=template-admin state.apply admin.install
fi

%preun


%changelog
* Mon Jul 13 2026 unman <unman@thirdeyesecurity.org>
- Fix rewriting repo def if caching proxy installed
* Mon Jul 13 2026 unman <unman@thirdeyesecurity.org>
- First Build
