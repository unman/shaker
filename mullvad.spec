Name:           3isec-qubes-mullvad-vpn
Version:       	2.01
Release:        1%{?dist}
Summary:        Set up a Mullvad wireguard proxy in Qubes

License:        GPLv3+
SOURCE0:	      mullvad

%description
This package sets up a VPN gateway, named MullvadVPN
It follows the method detailed in the Mullvad docs,
https://mullvad.net/en/help/qubes-os-4-and-mullvad-vpn/

This package is for use with wireguard.
If you use openvpn, install the 3isec-qubes-openvpn package.

The package creates a qube called MullvadVPN based on the debian-11-minimal
template.  If the debian-11-minimal template is not present, it will
be downloaded and installed - this may take some time depending on your
net connection.

There are changes to the firewall rules on MullvadVPN to ensure
blocking of outbound connections.
Only traffic to the Mullvad gateway is allowed.

After installing the package, copy your Mullvad configuration file or
zip file to MullvadVPN.
A menu item for "Setup Mullvad VPN" will be created on the main Qubes Menu.
Run this to set up the VPN.
When finished, restart MullvadVPN.

To use the VPN, set MullvadVPN as the netvm for your qubes(s).
All traffic will go through the VPN.
The VPN will fail closed if the connection drops.
No traffic will go through clear.

If you remove the package, the salt files will be removed.
**The MullvadVPN gateway will also be removed.**
To do this ALL qubes will be checked to see if they use MullvadVPN.
If they do, their netvm will be set to `none`.

You can, of course, use template-mullvad to create other VPN gateways.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt
cp -rv %{SOURCE0}/qubes-setup-MullvadVPN.desktop %{buildroot}/usr/share/applications
cp -rv %{SOURCE0}/setup_MullvadVPN.sh %{buildroot}/usr/bin/setup_MullvadVPN.sh

%files
%defattr(-,root,root,-)
/srv/salt/mullvad/*
/usr/share/applications/qubes-setup-MullvadVPN.desktop
/usr/bin/setup_MullvadVPN.sh

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply mullvad.clone
  qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.repo
  qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.browser
  qubesctl state.apply mullvad.create
  qubesctl --skip-dom0 --targets=MullvadVPN state.apply mullvad.configure
fi

%postun
if [ $1 -eq 0 ]; then
  for i in `qvm-ls -O NAME,NETVM | awk '/ MullvadVPN/{ print $1 }'`;do qvm-prefs $i netvm none; done
  qvm-kill MullvadVPN
  qvm-remove --force MullvadVPN template-mullvad 
fi

%changelog
* Sat Feb 10 2024 unman <unman@thirdeyesecurity.org> - 2.01
- Rewrite to use Mullvad GUI for connections
- Include Mullvad Browser
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.02
- Use pillar for cacher to determine repo changes
* Mon Nov 28 2022 unman <unman@thirdeyesecurity.org> - 1.1
- Fix wireshark typo
* Mon Aug 08 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
