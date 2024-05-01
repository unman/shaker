Name:           3isec-qubes-common
Version:        1.1
Release:        2%{?dist}
Summary:        Common files for 3isec packages

License:        GPLv3+
SOURCE0:        3isec-common

%description
This package provides base sls files for use by other 3isec packages

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/3isec-common/*

%post

%preun

%changelog
* Wed May 01 2024 unman <unman@thirdeyesecurity.org> 1.1.2
- Add store.clone files
* Mon Mar 11 2024 unman <unman@thirdeyesecurity.org>
- First Build
