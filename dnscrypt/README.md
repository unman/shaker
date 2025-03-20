# Introduction
These files create a template, with dnscrypt-proxy installed.
An AppVM named sys-dnscrypt, is created from that template.

## Template
The template, template-dnscrypt, is cloned from the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

## Usage
sys-dnscrypt is created with `provides_network` set, so you can attach qubes to it, setting it as netvm.

As with all Debian templates, services are masked in the template.
This is done in `create.sls`

By default sys-dnscrypt has sys-net as netvm, but you can change this if you wish.

## Installation
Copy the dnscrypt folder to /srv/salt.
```
qubesctl state.apply dnscrypt.clone
qubesctl --skip-dom0 --targets=template-dnscrypt state.apply dnscrypt.install
qubesctl state.apply dnscrypt.create
qubesctl --skip-dom0 --targets=sys-dnscrypt state.apply dnscrypt.configure
```
### Template creation
Clone the debian-12-minimal template - note the use of `qvm.template_installed` which will install the template if it is not already present
```
sudo qubesctl state.apply dnscrypt.clone
```

### Installation
```
sudo qubesctl --skip-dom0 --targets=template-dnscrypt state.apply dnscrypt.install
```
This state uses `archive.extracted` to extract the tarfile to `/etc/skel`.
This ensures that the dnscrypt-proxy application will be available in /home/user in all qubes created from the template.
Note that `archive.extracted` can take the source file specified using `salt://` to target files on the host.

The service is installed with all files in a single source directory, and uses default parameters.

### Qube creation
`create.sls` is a standard way of creating `sys-dnscrypt` - qvm.present is used to create the qube, and preferences and features are set.


### Configuration
`configure.sls` sets the firewall rules to drop forwarded DNS traffic, to dnat incoming DNS traffic to the service on sys-dnscrypt, and to allow that traffic to reach the server.
DNAT rules are also set in /rw/config/network-hooks.d to ensure they are not overwritten, and to keep traffic from vif* interfaces set on localnet.

## Notes
The service is installed from a release tarball, not from a system package.
This means that updating requires some manual intervention.

The service is to be manually started on sys-dnscrypt, as preferred by the developers.
The application has not been set to run as a service.
This could be done with use of `bind-dirs`.
