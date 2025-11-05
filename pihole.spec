Name:           3isec-qubes-pihole
Version:        1.5
Release:        1%{?dist}
Summary:        Creates Pi-hole server for Qubes

License:        GPLv3+
SOURCE0:        pihole

%description
This is Pi-hole.
It blocks advertisements and internet trackers by providing a DNS sinkhole.

The package will create a new standalone qube, sys-pihole.
It is a drop in replacement for sys-firewall.
Sys-pihole is attached to sys-net.
If you have sys-firewall as the default netvm, this will be changed to sys-pihole.
The installation will try to move all qubes with netvm of sys-firewall to sys-iphole.
sys-firewall will *not* be removed, so you can still use it for some qubes if you want.

 If you want to use Tor, then you should reconfigure your system like this:
 qubes -> sys-pihole ->Tor-gateway -> sys-firewall -> sys-net

You can clone sys-pihole.
If you do you must manually change the IP address of the clone.

Pi-hole will be installed with these default settings:
 The DNS provider is Quad9 (filtered, DNSSEC)
 StevenBlack's Unified Hosts List is included
 The web interface is availble at http://localhost/admin
 Query logging is enabled to show everything.

You can change these settings by logging in to the admin interface at http://localhost/admin
The default Admin Webpage login password is UpSNQsy4
You should change this on first use, by running:
`pihole -a -p`

Removing this package will only remove the salt files from /srv/salt.
It will NOT remove the sys-pihole qube.
It will NOT change Qubes networking.
You will have to make any changes as you wish.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/pihole/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply pihole.create
  qubesctl --skip-dom0 --targets=sys-pihole state.apply pihole.install
  /srv/salt/pihole/change_netvm.sh
fi

%preun


%changelog
* Thu Oct 30 2025 unman <unman@thirdeyesecurity.org> - 1.5
- Update package for 4.3
- Rebase on debian-13. 
* Sat Feb 03 2024 unman <unman@thirdeyesecurity.org> - 1.4
- Update package for Qubes 4.2
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.3
- Use pillar for cacher to determine repo changes
* Fri Sep 9 2022 unman <unman@thirdeyesecurity.org>
- Include dom0-update,so full replacement for sys-firewall.

* Fri Aug 5 2022 unman <unman@thirdeyesecurity.org>
- First Build
