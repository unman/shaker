Name:           3isec-qubes-reader
Version:        0.1
Release:        1%{?dist}
Summary:        Prepares useful software in Qubes

License:        GPLv3+
SOURCE0:        reader

%description
This package creates a minimal template configured with a range of useful software.
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
fi

%preun


%changelog
* Fri Sep 09 2022 unman <unman@thirdeyesecurity.org>
- First Build
