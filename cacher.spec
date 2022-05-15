Name:           cacher
Version:       	1.3
Release:        1%{?dist}
Summary:        Salt a caching proxy in Qubes

License:        GPLv3+
SOURCE0:	cacher

%description
Salt state to implement a caching proxy

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/cacher/*

%post
if [ $1 -eq 1 ]; then
  echo "------------------------"
  echo "cacher is being installed"
  echo "------------------------"
  qubesctl state.apply cacher.create
  qubesctl --skip-dom0 --targets=template-cacher state.apply cacher.install
  qubesctl --skip-dom0 --targets=cacher state.apply cacher.configure
  qubesctl state.apply cacher.use
  qubesctl --skip-dom0 --templates state.apply cacher.change_templates
fi

%preun
if [ $1 -eq 0 ]; then
  qubesctl --skip-dom0 --templates state.apply cacher.restore_templates
fi

%postun
if [ $1 -eq 0 ]; then
  sed -i /qubes.Gpg.*target=gpg/d /etc/qubes/policy.d/30-user.policy
fi

%changelog
* Sun May 15 2022 unman <unman@thirdeyesecurity.org> - 1.3
- General tidy up
- Automate configuration for standard templates on install
- Remove configuration on package removal.

* Fri May 13 2022 unman <unman@thirdeyesecurity.org>
- Update to handling fedora 35 in pool  
- add archlx_mirrors for pooling
- automatically salt all templates to use this proxy

* Fri May 06 2022 unman <unman@thirdeyesecurity.org>
- Update to debian-11-minimal base

* Wed Feb 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
