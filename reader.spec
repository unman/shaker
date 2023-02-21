Name:           3isec-qubes-reader
Version:        1.0
Release:        1%{?dist}
Summary:        Prepares useful software in Qubes

License:        GPLv3+
SOURCE0:        reader

%description
This package creates a minimal template configured with a range of useful software, of particular use to terminal users.
The template is set as the default template and as template for the Debian disposable template.

Removing this package does NOT revert these changes.
It only removes the salt files.
You must manually create another template and set it as the default using qubes-global-settings, and qubes-template-manager


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/reader/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply reader.clone
  qubesctl --skip-dom0 --targets=template-reader state.apply reader.install
elif [ $1 -eq 2 ]; then
  qubesctl state.apply reader.clone
fi

%preun


%changelog
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.0
- Use pillar for cacher to determine repo changes
* Sat Nov 26 2022 unman <unman@thirdeyesecurity.org>
- Fix error on setting templates
* Fri Sep 09 2022 unman <unman@thirdeyesecurity.org>
- First Build
