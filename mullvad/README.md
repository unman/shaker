# Introduction
These files create a template, loaded with the MullvadVPN GUI and Mullvad Browser. 
An AppVM named sys-mullvad, and a disposable template, mullvad-dvm, are
created from that template.

## Template
The template, template-mullvad, is cloned from the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

## Usage
Both the AppVM and the disposable template have the Mullvad GUI to
set up a VPN, and the Mullvad browser. You can run the Mullvad Browser
independently of the VPN.
The sys-mullvad AppVM can be used as a standard AppVM or as a vpn gateway
- set the netvm of client qubes to sys-mullvad, and they will use the VPN. No
traffic will pass except through the VPN.

You can, of course, use template-mullvad to create other qubes for
separate VPN connections, or a qube where you will just use the Mullvad browser.

Remember that each qube that creates a VPN will count toward the maximum of 5 clients.
Log out and close the VPN when you have finished with it: if you do  not,
you will be prompted to log out other clients from the GUI when you reach the maximum.

## Template creation
Clone the debian-12-minimal template - note the use of `qvm.template_installed` which will install the template if it is not already present
```
sudo qubesctl state.apply mullvad.clone
```
`clone.sls` uses `qvm.features` to set the menu. Note that you can do this *before* packages are installed.

## Package installation
```
sudo qubesctl --skip-dom0 --targets=template-mullvad state.apply mullvad.repo

```
This state uses `pkg.installed` to install necessary packages in the template.
`cmd.run` is used to create the mullvad respository definition, and the keyring is copied in to place using `file.managed`
Mullvad packages are installed using `pkg.installed`, and desktop files are copied in to `etc/skel` in the template. This is necessary because we need custom versions to run Mullvad programs in Qubes disposables.


Note the use of `pillar.get` to check if a caching proxy is present, and the necessary changes to repository defintions are made using `file.replace` within a jinja command structure.

## Qube creation
`create.sls` is a standard way of creating `sys-mullvad` - qvm.present is used to create the qube, and preferences and features are set.

`create_disposable.sls` creates a qube and sets it as a disposable template. The Menu is configured and qvm-appmenus` is called using `cmd.run  to make sure that menu items are correctly set.

Note the use of an include statement at the head of the file. This allows a single state execution to call other states.


## Qube configuratioon
```
sudo qubesctl --skip-dom0 --targets=sys-mullvad state.apply mullvad.configure
```
The qubes firewall is configured using `file.managed` to transfer files to sys-mullvad. These are normal nftables command files.
To make sure that configuration changes are kept after a qubes restart, [bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) is used.
The configuration file is created using `file.managed`
