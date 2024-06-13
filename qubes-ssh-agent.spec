Name:           3isec-qubes-sys-ssh-agent
Version:       	1.3
Release:        2%{?dist}
Summary:        Create a service qube to hold ssh-agents

License:        GPLv3+
SOURCE0:        qubes-ssh-agent

%description
This package sets up a qube called sys-ssh-agent, to hold ssh keys.
It is ideal for use cases where you have a number of key pairs, which
are used by different qubes.

The keypairs are stored in the offline sys-ssh-agent server, and requests
are passed from clients to the server via qrexec.
Clients may access the same ssh-agent, or access different agents.  
Access is controlled via dom0 policy file, /etc/qubes/policy.d/30-user.policy

The client does not know the identity of the ssh-agent server, nor are
keys kept in memory in the client.
All configuration of keys, and unlocking of keys, where they are password
protected, is done in the ssh-agent server, using standard ssh-agent
controls.
Keys can be selectively allocated to different ssh-agents.
You can create multiple ssh-agents holding different combination of ssh keys.
This allow you to access different key sets from different qubes.
By default an ssh-agent called "work" is provided in sys-ssh-agent.
Helper scripts are provided to create new ssh-agents.

You can create other qubes to hold other ssh-agents if you  want, for
maximum compartmentalisation.
Simply clone sys-ssh-agent and edit the ssh-agents.

Removing this package will NOT delete the qubes, but will remove the 
entry in /etc/qubes/policy.d/50-


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
  qubesctl --skip-dom0 --targets=template-ssh-agent state.apply qubes-ssh-agent.configure_template
  qubesctl --skip-dom0 --targets=sys-ssh-agent state.apply qubes-ssh-agent.configure
fi

%postun
if [ $1 -eq 0 ]; then
  sed -i /qubes.SshAgent/d /etc/qubes/policy.d/50-config-splitssh.policy
fi

%changelog
* Wed Jun 12 2024 unman <unman@thirdeyesecurity.org> - 1.3
- Upgrade template to debian-12-minimal
* Mon Feb 20 2023 unman <unman@thirdeyesecurity.org> - 1.2
- Use pillar for cacher to determine repo changes
* Mon Jun 06 2022 unman <unman@thirdeyesecurity.org> - 1.1
- Update post scripts
* Sun May 22 2022 unman <unman@thirdeyesecurity.org> - 1.0
- First Build
