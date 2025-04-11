# Introduction
These files create a template, with Tailscale installed as per Tailscale [instructions](https://pkgs.tailscale.com/stable/#debian-bookworm)
An AppVM named sys-tailscale is created from that template.

## Template
The template, template-tailscale, is cloned from the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

## Usage
The sys-tailscale AppVM can be used as a standard AppVM or as a Tailscale client

You can, of course, use template-tailscale to create other qubes for
separate VPN connections.

Remember that each qube that creates a VPN will count toward your limit.

## Template creation
Clone the debian-12-minimal template - note the use of `qvm.template_installed` which will install the template if it is not already present
```
sudo qubesctl state.apply tailscale.clone
```

## Package installation
```
sudo qubesctl --skip-dom0 --targets=template-tailscale state.apply tailscale.install

```
This state uses `pkg.installed` to install the Tailscale packages in the template.
Note the use of `pillar.get` to check if a caching proxy is present, and the necessary changes to repository defintions are made using `file.replace` within a jinja command structure.

The tailscaled service is disabled and amked in the template.

## Qube creation
`create.sls` is a standard way of creating `sys-tailscale` - qvm.present is used to create the qube, and preferences and features are set.

Note the use of an include statement at the head of the file. This allows a single state execution to call other states.


## Qube configuratioon
```
sudo qubesctl --skip-dom0 --targets=sys-tailscale state.apply tailscale.configure
```
Changes to `/rw/config/rc.local` are written using `file.append` to start tailscaled and bring up Tailscale.
To make sure that configuration changes are kept after a qubes restart, [bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) is used.
The configuration file is created using `file.managed`
