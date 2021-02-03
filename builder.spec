Name:           template-builder
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt builder template

License:        GPLv3+
SOURCE0:	builder

%description
Salt state for Qubes builder template

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/builder/*

%changelog
* Wed Fed 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
