Name:           3isec-qubes-cacher
Version:       	1.12
Release:        1%{?dist}
Summary:        A caching proxy in Qubes

License:        GPLv3+
SOURCE0:        cacher

%description
This package provides a caching proxy qube, named cacher.
A caching proxy stores downloaded packages, so that you need only download
a package once for it to be used when updating many templates.
The proxy is preconfigured to work out of the box for Debian, Ubuntu,
Arch, and Fedora templates.

When you install this package your Qubes system will be altered to use
the proxy by default.
This is done with an entry in /etc/qubes/policy.d/50-config-updates.policy
in Qubes 4.2
If you want to change the proxy setting for some/all templates, edit
that file, or use the GUI global settings tool.

So that you can use https:// in your repository definitions, the entries
will be changed in the templates.
 https:// becomes http://HTTPS///
This is so that the request to the proxy is plain text, and the proxy 
will then make the request via https
This change will be done automatically for every template that exists
when you install this package.

If you install a new template, you must make this configuration change. 
In dom0 run:
 qubesctl --skip-dom0 --targets=TEMPLATE state.apply cacher.change_templates  
replacing TEMPLATE with the name of the new template. 

If you want to use the standard proxy, you have to revert this change,
as well as editing the policy file.
In dom0 run:
 qubesctl --skip-dom0 --targets=TEMPLATE state.apply cacher.restore_templates  
replacing TEMPLATE with the name of the new template. 

When this package is installed it will attempt to rewrite repository
definitions in all templates.
This includes templates that are not under salt control, like Windows
templates.
You must manually shutdown those templates.

No changes are made to Whonix templates, and updates to those templates
will not be cached.

If you want updates to run via Tor, set the netvm for the cacher qube
to be a Tor proxy, like sys-whonix.

Because the cacher qube is listening on port 8082, you can use it from
non-template qubes and qubes that do not have a working qrexec. Use
the native configuration to set the update proxy using the IP address
of cacher.

A pillar is created to hold the caching qube.
This can be referenced from other salt states as needed.

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
elif [ $1 -eq 2 ]; then
  qubesctl --skip-dom0 --targets=template-cacher state.apply cacher.update
fi

%preun
if [ $1 -eq 0 ]; then
  qubesctl --skip-dom0 --templates state.apply cacher.restore_templates
fi

%postun
if [ $1 -eq 0 ]; then
  sed -i /qubes.UpdatesProxy.*target=cacher/d /etc/qubes/policy.d/50-config-updates.policy
  rm /srv/pillar/_tops/base/update_proxy.top
  rm /srv/pillar/update_proxy/init.top
  rm /srv/pillar/update_proxy/init.sls
fi

%changelog
* Tue Jan 30 2024 unman <unman@thirdeyesecurity.org> - 1.12
- Update file locations for use in Qubes 4.2
* Thu Nov 30 2023 unman <unman@thirdeyesecurity.org> - 1.11
- Change base template to Debian-12-minimal for new install.
- Update fedora mirror list
- Change packaging logic on handling pillar when deleting package 
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.10
- Create pillar for cacher
* Sun Jan 29 2023 unman <unman@thirdeyesecurity.org> - 1.9
- Change packaging so that upgrade will update mirror lists and config
- Update fedora mirror list
- Update configuration to handle issues with fedora repositories
- Use baseurl in rpmfusion repositories
- Include anacron
* Mon Aug 22 2022 unman <unman@thirdeyesecurity.org> - 1.8
- Stop rewriting for Whonix templates
* Sun Aug 21 2022 unman <unman@thirdeyesecurity.org> - 1.7
- Correct uninstall action
* Thu Jul 28 2022 unman <unman@thirdeyesecurity.org> - 1.5
- Extended description
* Sat May 21 2022 unman <unman@thirdeyesecurity.org> - 1.4
- Standardise package names to 3isec-
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
