Name:           cacher
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt a caching proxy

License:        GPLv3+
SOURCE0:	cacher

%description
Salt state to implement a caching proxy

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/cacher/*

%changelog
* Wed Fed 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
