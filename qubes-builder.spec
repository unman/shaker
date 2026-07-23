Name:           3isec-qubes-builder
Version:  	    1.1
Release:        1%{?dist}
Summary:        Salt builder template

License:        GPLv3+
SOURCE0:	      qubes-builder

%description
Salt state for qubes-builder template and qube

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt/qubes-builder
cp -rv %{SOURCE0}/*  %{buildroot}/srv/salt/qubes-builder

%files
%defattr(-,root,root,-)
/srv/salt/qubes-builder/*

%post
qubesctl state.apply qubes-builder.create
qubesctl --skip-dom0 --targets=template-qubes-builder state.apply qubes-builder.install
qubesctl --skip-dom0 --targets=qubes-builder state.apply qubes-builder.config


%changelog
* Wed Jul 22 2026 unman <unman@thirdeyesecurity.org>
- First Build
