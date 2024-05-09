Name:           3isec-qubes-mirage-firewall
Version:       	0.9.0
Release:        1%{?dist}
Summary:        Create an Mirage firewall in Qubes

License:        GPLv3+
SOURCE0:        mirage

%description
This package creates a mirage firewall for use in Qubes.
It's a Unikernel qube to replace sys-firewall, which uses minimal system resources.
For full details:
https://github.com/mirage/qubes-mirage-firewall

The package creates a qube called mirage-firewall.
If you want to use this as a firewall, simply change net qube from sys-firewall to mirage-firewall.

Removing this package will remove the mirage-firewall.
Qubes that use it will have their net qube unset.
You will have to change netqube to get those qubes back online.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/mirage/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply mirage.install
elif [ $1 -eq 2 ]; then
  qubesctl state.apply mirage.extract
fi

%postun
if [ $1 -eq 0 ]; then
  qvm-kill mirage-firewall
  qvm-remove --force mirage-firewall
fi

%changelog
* Thu May 09 2024 unman <unman@thirdeyesecurity.org> - 0.9.0
- Packages qubes-mirage-firewall 0.9.0
* Sat Feb 03 2024 unman <unman@thirdeyesecurity.org> - 0.8.6
- Packages qubes-mirage-firewall 0.8.6
* Mon Apr 17 2023 unman <unman@thirdeyesecurity.org> - 0.8.4
- Packages qubes-mirage-firewall 0.8.4
