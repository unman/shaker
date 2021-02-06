Name:           gpg
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt gpg template

License:        GPLv3+
SOURCE0:	gpg

%description
Salt state to implement split-gpg

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/gpg/*

%changelog
* Wed Fed 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
