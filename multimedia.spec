Name:           template-multimedia
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt multimedia template

License:        GPLv3+
SOURCE0:	multimedia

%description
Salt state for multimedia template

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/multimedia/*

%changelog
* Wed Fed 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
