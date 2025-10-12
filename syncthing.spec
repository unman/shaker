Name:       3isec-qubes-syncthing
Version:    1.4
Release:    1%{?dist}
Summary:    Syncthing in Qubes

License:    GPLv3+
SOURCE0:    syncthing
Requires:   3isec-qubes-common

%description
Creates a syncthing template and active syncthing qube.
By default the syncthing qube will be attached to sys-firewall, or sys-pihole if that qube exists.
It makes no sense to run this with syncthing attached to a VPN or Tor proxy.

A qubes.Syncthing service is created, to allow use of syncthing over qrexec.
A default policy is set in /etc/qubes/policy.d/30-user.policy to deny all.
If you want to allow syncthing between qubes, insert a line at the top of the policy file to allow. E.g:
  qubes.Syncthing  *  FROM  TO  allow

A script is provided in /srv/salt/3isec-common/.in.sh to allow for inbound connections.
This script opens up the qubes-firewall, so that the syncthing qube is accessible externally.
If sys-net has more than one network card the FIRST external interface will be used by default.
(If this is incorrect, you must change it manually. In dom0:
  /srv/salt/syncthing/in.sh delete syncthing tcp 22000 -a -p
  /srv/salt/syncthing/in.sh delete syncthing udp 22000 -a -p
  /srv/salt/syncthing/in.sh add syncthing tcp 22000 -p
  /srv/salt/syncthing/in.sh add syncthing udp 22000 -p
This will let you choose the NIC.)

The package can be uninstalled using:
  sudo dnf remove 3isec-qubes-syncthing
The syncthing qube will NOT be removed, but the Syncthing service on that qube will be stopped.
N.B. If you have manually set firewall rules you must manually revert them.
The qrexec policy will be reverted to stop Syncthing between qubes.

The package includes qubes-rsyncthing.service.
This enables use of syncthing between qubes over qrexec - the service must be enabled to be used:
  qubes-features QUBE service.qubes-syncthing 1
By default the service will connect to the syncthing qube.
To use the service, add a Remote Device, and copy the DeviceID from the target qube.
On the Advanced tab, under Addresses, change "dynamic" to "tcp://127.0.0.1:22001"

If the sender qube has no netvm set, under "Settings", disable "Enable NAT traversal", "Local Discovery",
"Global Discovery", and "Enable Relaying"


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt/syncthing
cp -rv %{SOURCE0}/*  %{buildroot}/srv/salt/syncthing

%files
%defattr(-,root,root,-)
/srv/salt/syncthing/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply syncthing.clone
  qubesctl --skip-dom0 --targets=template-syncthing state.apply syncthing.install
  qubesctl state.apply syncthing.create
  qubesctl --skip-dom0 --targets=syncthing state.apply syncthing.configure
  /srv/salt/syncthing/in.sh -a -p add syncthing tcp 22000
  /srv/salt/syncthing/in.sh -a -p add syncthing udp 22000
fi

%preun
if [ $1 -eq 0 ]; then
  /srv/salt/syncthing/in.sh -a -p delete syncthing tcp 22000
  /srv/salt/syncthing/in.sh -a -p delete syncthing udp 22000
  qubesctl --skip-dom0 --targets=syncthing state.apply syncthing.cancel
  qubesctl state.apply syncthing.clean
fi

%postun

%changelog
* Sun Sep 12 2025 unman <unman@thirdeyesecurity.org> - 1.4.1
- Bump version
* Thu Jun 12 2024 unman <unman@thirdeyesecurity.org> - 1.2.2
- Improve script for inbound connections
- Drop automatic configuration in favor of manual.
- Move script to common files for general use
* Sat Jan 20 2024 unman <unman@thirdeyesecurity.org> - 1.2
- Update for 4.2 - new base template, remove iptables references.
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.1
- Use pillar for cacher to determine repo changes
* Fri Sep  9 2022 unman <unman@thirdeyesecurity.org>
- Better handling of open ports
- Clean up on package removal
- Fix typos in repo definition
* Mon Aug 29 2022 unman <unman@thirdeyesecurity.org>
- First Build
