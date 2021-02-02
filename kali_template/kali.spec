Name:           kali
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt Kali template

License:        GPLv3+
SOURCE0:	kali

%description
Salt state for Kali template


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/kali/*

%changelog
* Sun Jan 31 2021 unman <unman@thirdeyesecurity.org>
- First Build
