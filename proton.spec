Name:           3isec-qubes-proton-vpn
Version:       	1.01
Release:        2%{?dist}
Summary:        Set up a qube for Proton VPN use

License:        GPLv3+
SOURCE0:	      proton

%description
This package creates a template, using the proton repository, and
with the Proton VPN GUI installed.
Some useful networking programs (firefox,thunderbird,netcat,ssh,wget), are
pre-installed
An AppVM named proton, is created from that template.

The template, template-proton, is based on the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

If you remove this package, the salt files will be removed, and the proton
template and qube will be killed and an attempt made to remove them.

You can, of course, use the template-proton to create other qubes for
separate VPN connections.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/proton/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply proton.create
  qubesctl --skip-dom0 --targets=template-proton state.apply proton.install_repo
  qubesctl --skip-dom0 --targets=template-proton state.apply proton.install
fi

%postun
if [ $1 -eq 0 ]; then
  qvm-kill proton template-proton
  qvm-remove -f proton template-proton
fi

%changelog
* Sat Feb 17 2024 unman <unman@thirdeyesecurity.org> - 1.01
- First Build
