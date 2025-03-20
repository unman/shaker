Name:           3isec-qubes-dnscrypt
Version:        1.1
Release:        1%{?dist}
Summary:        Provides a template and qube providing DNSCrypt in Qubes

License:        GPLv3+
SOURCE0:        dnscrypt

%description
This package creates a template with dnscrypt-proxy installed.
The template is based on the debian-12-minimal template.
A template based qube, sys-dnscrypt, is created with a vanilla version of dnscrypt-proxy installed.
The new qube is configured to drop in to the Qubes networking model.
It supports qubes-firewall.
However, NO DNS traffic is forwarded, and all such traffic is passed through dnscrypt-proxy.
The installation follows the documentation but the service must be manually started.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/dnscrypt/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply dnscrypt.clone
  qubesctl --skip-dom0 --targets=template-dnscrypt state.apply dnscrypt.install
  qubesctl state.apply dnscrypt.create
  qubesctl --skip-dom0 --targets=sys-dnscrypt state.apply dnscrypt.configure
elif [ $1 -eq 2 ]; then
  qubesctl state.apply dnscrypt.clone
fi

%preun


%changelog
* Thu Mar 20 2025 unman <unman@thirdeyesecurity.org>
- First Build
