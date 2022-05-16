Name:           sys-multimedia
Version:  	2.1
Release:        1%{?dist}
Summary:        Salt multimedia template and qubes

License:        GPLv3+
SOURCE0:	multimedia

%description
Salt state for multimedia template and qubes

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/multimedia/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply multimedia.create
  qubesctl --skip-dom0 --targets=template-multimedia state.apply multimedia.install
  qubesctl --skip-dom0 --targets=media state.apply multimedia.configure
fi

%changelog
* Sun May 15 2022 unman <unman@thirdeyesecurity.org> - 2.0
- Add post install salting
* Wed Feb 03 2021 unman <unman@thirdeyesecurity.org>
- First Build
