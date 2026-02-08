Name:           kali
Version:        2.0
Release:        1%{?dist}
Summary:        Salt Kali template

License:        GPLv3+
SOURCE0:        kali

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
* Sun Feb 08 2026 unman <unman@thirdeyesecurity.org>
- Rebase to Forky
* Sun Jan 31 2021 unman <unman@thirdeyesecurity.org>
- First Build
