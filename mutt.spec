Name:           3isec-qubes-mutt
Version:  	2
Release:        1%{?dist}
Summary:        Prepares qube for using mutt in Qubes
Requires:       3isec-qubes-common

License:        GPLv3+
SOURCE0:        mutt

%description
This package creates a minimal template configured for using mutt in Qubes, including notmuch.
There is a helper script to make it easy to set up mutt.
By default, attachments will be opened in a disposable.

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
  qubesctl --skip-dom0 --targets=template-mutt state.apply 3isec-common.mutt.install
  qubesctl state.apply mutt.configure
  qvm-shutdown template-mutt
fi

%preun


%changelog
* Thu Jun 13 2024 unman <unman@thirdeyesecurity.org> - 2.1
- Upgrade base to debian 12
* Mon Mar 11 2024 unman <unman@thirdeyesecurity.org> - 2.0
- Move common mutt install files to 3isec-common package
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.1
- Use pillar for cacher to determine repo changes
* Wed Jul 14 2021 unman <unman@thirdeyesecurity.org>
- First Build
