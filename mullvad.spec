Name:           3isec-qubes-mullvad-vpn
Version:       	2024.3
Release:        1%{?dist}
Summary:        Set up a Mullvad qube and disposable template

License:        GPLv3+
SOURCE0:	mullvad

%description
This package creates a template, loaded with the MullvadVPN GUI and Mullvad Browser. 
An AppVM named sys-mullvad, and a disposable template, mullvad-dvm, are
created from that template.

The template, template-mullvad, is based on the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

Both the AppVM and the disposable template have the Mullvad GUI to
set up a VPN, and the Mullvad browser. You can run the Mullvad Browser
independently of the VPN.
The sys-mullvad AppVM can be used as a standard AppVM or as a vpn gateway
- set the netvm of client qubes to mullvad, and they will use the VPN. No
traffic will pass except through the VPN.

If you remove this package, the salt files will be removed, but the qubes will not.
You can manually remove them if you wish.

You can, of course, use template-mullvad to create other qubes for
separate VPN connections, or a qube where you will just use the Mullvad browser.

Remember that each qube that creates a VPN will count toward the maximum of 6 clients.
Log out and close the VPN when you have finished with it: if you do  not,
you will be prompted to log out other clients from the GUI.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/mullvad/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply mullvad.clone
  qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.repo
  qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.browser
  qubesctl state.apply mullvad.create_disposable
  qubesctl --skip-dom0 --targets=sys-mullvad state.apply mullvad.configure
elif [ $1 -eq 2 ]; then
  qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.browser
fi

%postun
if [ $1 -eq 0 ]; then
fi

%changelog
* Sat May 18 2024 unman <unman@thirdeyesecurity.org> - 2024.3.1
- Update to Mullvad VPN 2024.3
- Update to include new Mullvad Browser 13.0.15
* Sat Mar 16 2024 unman <unman@thirdeyesecurity.org> - 2023.6.2
- Update to include new Mullvad Browser
- Use sys-mullvad as transparent VPN proxy
* Sat Feb 10 2024 unman <unman@thirdeyesecurity.org> - 2.01
- Rewrite to use Mullvad GUI for connections
- Include Mullvad Browser
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.02
- Use pillar for cacher to determine repo changes
* Mon Nov 28 2022 unman <unman@thirdeyesecurity.org> - 1.1
- Fix wireshark typo
* Mon Aug 08 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
