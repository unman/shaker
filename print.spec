Name:           3isec-qubes-sys-printer
Version:       	1.3
Release:        1%{?dist}
Summary:        Salt a printer qube in Qubes

License:        GPLv3+
SOURCE0:	print

%description
This package sets up a qube called sys-print, to be used for system-wide
printing in Qubes.
 
You configure sys-print to access your printer, and then print from any
other qube by accessing sys-print.
If you have a USB printer you will need to configure sys-print with
(at least) one of your USB controllers.
If you have a network printer, you should be able to set up from
sys-print, and then print from offline qubes.
You should restrict access from sys-print to the IP of the printer using
qubes firewall.

You can create more than one qube to act as a printer qube if you want.
The system will be configured to use the sys-printer qube by default.
This is done with an entry in /etc/qubes/policy.d/30-user.policy
If you want to change the setting for some/all qubes, edit
that file.

A specific service called qubes.Print is created.
You have to configure your qubes to use that service, and a helper script
is provided.
In dom0, run:
 sudo qubesctl --skip-dom0 --targets=NAMES state.apply print.print_client

Removing this package will NOT delete the qubes, but will remove the
entry in /etc/qubes/policy.d/30-user.policy.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/print/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply print.create
  qubesctl --skip-dom0 --targets=template-printer state.apply print.install
  qubesctl --skip-dom0 --targets=sys-printer state.apply print.configure
fi

%postun
if [ $1 -eq 0 ]; then
  sed -i /qubes.Print/d /etc/qubes/policy.d/30-user.policy
fi

%changelog
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.3
- Use pillar for cacher to determine repo changes
* Sun May 22 2022 unman <unman@thirdeyesecurity.org> - 1.2
- Add template and package installation to  post
* Sat May 21 2022 unman <unman@thirdeyesecurity.org> - 1.1
- Standardise package names to 3isec-
* Sun May 15 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
