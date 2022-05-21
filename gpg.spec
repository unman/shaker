Name:           3isec-qubes-split-gpg
Version:  	2.0
Release:        1%{?dist}
Summary:        Salt split-gpg template in Qubes

License:        GPLv3+
SOURCE0:	gpg

%description
Salt state to implement split-gpg in Qubes

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
