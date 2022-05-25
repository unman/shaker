Name:           3isec-qubes-sys-ssh-agent
Version:       	1.0
Release:        1%{?dist}
Summary:        Salt a qube to hold ssh-agents

License:        GPLv3+
SOURCE0:	qubes-ssh-agent

%description
Salt state to implement a qube to hold ssh-agents

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/qubes-ssh-agent/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply qubes-ssh-agent.create
  qubesctl --skip-dom0 --targets=sys-ssh-agent state.apply qubes-ssh-agent.configure
fi

%postun
if [ $1 -eq 0 ]; then
  sed -i /qubes.SshAgent/d /etc/qubes/policy.d/30-user.policy
fi

%changelog
* Sun May 22 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
