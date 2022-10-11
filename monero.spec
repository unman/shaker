Name:           4isec-qubes-split-monero
Version:       	0.1
Release:        1%{?dist}
Summary:        Create a split monero wallet in Qubes

License:        GPLv3+
SOURCE0:	      monero

%description
This package creates an offline Monero wallet, which connects to a
Monero daemon over qrexec. All traffic from the daemon is forced to run
over Tor.
It follows the method detailed in the Monero docs:
 https://www.getmonero.org/resources/user-guides/cli_wallet_daemon_isolation_qubes_whonix.html

The package creates a qube called monero-wallet-ws to hold the wallet,
and monerod-ws for the monerod daemon. The netvm for this qube is set
to sys-whonix, so traffic should pass over Tor. (monero-wallet-ws has

Traffic between the daemon and the wallet runs over qrexec, controlled
by an entry in the policy file at /etc/qubes/policy/30-user.policy

You can create multiple wallets by cloning the wallet, and adding policy entries.
You can also clone the daemon and connect them to different Tor gateways.

If you remove the package, the salt files will be removed.
The Wallet qube will NOT be removed.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/srv/salt
cp -rv %{SOURCE0}/  %{buildroot}/srv/salt

%files
%defattr(-,root,root,-)
/srv/salt/monero/*

%post
if [ $1 -eq 1 ]; then
  qubesctl state.apply monero.create
  qubesctl --skip-dom0 --targets=monerod-ws state.apply monero.configure
  qubesctl --skip-dom0 --targets=monero-wallet-ws state.apply monero.configure_wallet
fi

%postun
if [ $1 -eq 0 ]; then
fi

%changelog
* Wed Oct 05 2022 unman <unman@thirdeyesecurity.org> - 0.1
- First Build
