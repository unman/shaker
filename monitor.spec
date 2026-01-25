Name:           3isec-qubes-monitor
Version:        2
Release:        1%{?dist}
Summary:        Prepares qube for network monitoring in Qubes

License:        GPLv3+
SOURCE0:        monitor

%description
This package creates a template, with tools installed for network monitoring.
An AppVM named sys-monitor, is created from that template.
The template, template-monitor, is cloned from the debian-13-minimal template.
If the debian-13-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.
sys-monitor is created with `provides_network` set, so you can attach qubes to it, setting it as the netvm.
Wireshark, suricata, tcpdump, and tcpflow are installed and ready to run.
The template has passwordless root installed, so you can run packet captures using `sudo..`.  
If you want to run wireshark as an ordinary user, you will have to follow the instructions in `/srv/salt/monitor/README.md` to reconfigure the package.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/monitor/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply monitor.create
  qubesctl --skip-dom0 --targets=template-monitor state.apply monitor.install
  qubesctl --skip-dom0 --targets=sys-monitor state.apply monitor.configure
fi

%preun


%changelog
* Sat Jan 24 2026 unman <unman@thirdeyesecurity.org> - 2.1
- Rebase to debian-13
* Sat Jul 27 2024 unman <unman@thirdeyesecurity.org> - 1.2
- Make suricata logs persistent
* Thu Jul 25 2024 unman <unman@thirdeyesecurity.org> - 1.1
- First Build
