Name:           3isec-qubes-split-gpg
Version:  	    2.0
Release:        1%{?dist}
Summary:        split-gpg in Qubes

License:        GPLv3+
SOURCE0:	      gpg

%description
 This package set up split-gpg in Qubes.
 split-gpg allows you to store your pgp keys in one qube, and access them from another.
 Full details are at https://www.qubes-os.org/doc/split-gpg/

When you install this package a template will be created, and a qube
named sys-gpg to hold the keys.
You can create more than one qube to hold keys if you want.
The system will be configured to use the sys-gpg qube by default.
This is done with an entry in /etc/qubes/policy.d/30-user.policy
If you want to change the setting for some/all qubes, edit
that file.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/gpg/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply gpg.create
  qubesctl --skip-dom0 --targets=template-gpg state.apply gpg.install
fi

%preun
if [ $1 -eq 0 ]; then
  sed -i /qubes.Gpg.*target=sys-gpg/d /etc/qubes/policy.d/30-user.policy
fi


%changelog
* Sat May 21 2022 unman <unman@thirdeyesecurity.org> - 1.4
- Standardise package names to 3isec-
* Sat May 14 2022 unman <unman@thirdeyesecurity.org> - 2.0
- Change preun script
* Sat May 14 2022 unman <unman@thirdeyesecurity.org> - 2.0
- Update to Qubes 4.1 
- Change policies on package install and removal 
* Wed Fed 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
