Name:           3isec-qubes-pihole
Version:  	    1.0
Release:        1%{?dist}
Summary:        Creates Pi-hole server for Qubes

License:        GPLv3+
SOURCE0:	      pihole

%description
This is Pi-hole.
It blocks advertisements and internet trackers by providing a DNS sinkhole.

The package will create a new standalone qube, sys-pihole.
It is a drop in replacement for sys-firewall.
Sys-pihole is attached to sys-net.
If you have sys-firewall as the default netvm, this will be changed to sys-pihole.
sys-firewall will *not* be removed, so you can still use it for some qubes if you want.
To use sys-pihole simply change the netvm.
If you want to change all your qubes from sys-firewall to sys-pihole, a script is provided:
Run `sudo /srv/salt/pihole/change_netvm.sh` .

 If you want to use Tor, then you should reconfigure your system like this:
 qubes -> sys-pihole ->Tor-gateway -> sys-firewall -> sys-net

You can clone sys-pihole.
If you do you must manually change the IP address of the clone.

Pi-hole will be installed with these default settings:
 The DNS provider is Quad9 (filtered, DNSSEC)
 StevenBlack's Unified Hosts List is included
 The web interface is availble at http://localhost
 Query logging is enabled to show everything.

You can change these settings by logging in to the admin interface at http://localhost.
The default Admin Webpage login password is UpSNQsy4
You should change this on first use, by running:
`pihole -a -p`

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
  if [[ $(qubes-prefs default_netvm sys-firewall |grep sys-firewall ) ]]; then qubes-prefs default_netvm sys-pihole; fi
fi

%preun


%changelog
* Fri Aug 5 2022 unman <unman@thirdeyesecurity.org>
- First Build
