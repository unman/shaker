Name:           3isec-qubes-sys-vpn
Version:       	1.0
Release:        1%{?dist}
Summary:        Salt a VPN proxy in Qubes

License:        GPLv3+
SOURCE0:	openvpn

%description
Salt state to implement a VPN proxy in Qubes

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/openvpn/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply openvpn.clone
  qubesctl --skip-dom0 --targets=template-openvpn state.apply openvpn.install
  qubesctl state.apply openvpn.create
  qubesctl --skip-dom0 --targets=sys-vpn state.apply openvpn.configure
fi

%postun
if [ $1 -eq 0 ]; then
  for i in `qvm-ls -O NAME,NETVM | awk '/ sys-vpn/{ print $1 }'`;do qvm-prefs $i netvm none; done
  qvm-kill sys-vpn
  qvm-remove --force sys-vpn template-openvpn 
fi

%changelog
* Wed May 18 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
