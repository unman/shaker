Name:           3isec-qubes-mutt
Version:  	    1.0
Release:        1%{?dist}
Summary:        Prepares qube for using mutt in Qubes

License:        GPLv3+
SOURCE0:	      mutt

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
  qubesctl --skip-dom0 --targets=template-mutt state.apply mutt.install
  qubesctl state.apply mutt.configure
fi

%preun


%changelog
* Wed Jul 15 2021 unman <unman@thirdeyesecurity.org>
- First Build
