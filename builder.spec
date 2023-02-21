Name:           3isec-qubes-builder
Version:  	    1.2
Release:        1%{?dist}
Summary:        Salt builder template

License:        GPLv3+
SOURCE0:	      builder

%description
Salt state for builder qube and template

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt/build
cp -rv %{SOURCE0}/*  %{buildroot}/srv/salt/build

%files
%defattr(-,root,root,-)
/srv/salt/build/*

%pos
qubesctl state.apply build.create
qubesctl --skip-dom0 --targets=template-builder state.apply build.install
qubesctl --skip-dom0 --targets=builder state.apply build.config


%changelog
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.02
- Use pillar for cacher to determine repo changes
* Sat May 21 2021 unman <unman@thirdeyesecurity.org>
- Change name
* Wed Feb 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
