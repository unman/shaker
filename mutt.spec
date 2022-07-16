Name:           3isec-qubes-mutt
Version:  	1.0
Release:        1%{?dist}
Summary:        Salt template for using mutt in Qubes

License:        GPLv3+
SOURCE0:	mutt

%description
Salt state to create template for using mutt in Qubes

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/mutt/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply mutt.clone
  qubesctl --skip-dom0 --targets=template-mutt state.apply mutt.install
fi

%preun


%changelog
* Wed Jul 15 2021 unman <unman@thirdeyesecurity.org>
- First Build
