Name:           deb11-minimal-salt
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt debian-11-minimal template in Qubes

License:        GPLv3+
SOURCE0:	templates

%description
Salt state to implement debian-11-minimal template in Qubes

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/*  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply template-debian-11-minimal
fi


%changelog
* Sat May 14 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
