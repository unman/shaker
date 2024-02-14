Name:           3isec-qubes-store
Version:        1.01
Release:        1%{?dist}
Summary:        A storage template using thunar

License:        GPLv3+
SOURCE0:        store

%description
This package creates a template with thunar installed, for use by offline storage qubes.
The template is based on the debian-12-minimal template.

Removing this package only removes the salt files, not the template.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/store/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply store.clone
  qubesctl --skip-dom0 --targets=template-store state.apply store.install
elif [ $1 -eq 2 ]; then
  qubesctl state.apply store.clone
fi

%preun


%changelog
* Mon Feb 12 2024 unman <unman@thirdeyesecurity.org> - 1.01
- First Build
