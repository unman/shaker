# Introduction
These files create a template, with tools installed for network monitoring.
An AppVM named sys-monitor, is created from that template.

## Template
The template, template-monitor, is cloned from the debian-12-minimal template.
If the debian-12-minimal template is not present, it will be downloaded
and installed - this may take some time depending on your net connection.

The template has passwordless root installed, so you can run packet captures using `sudo..`.  
If you want to run wireshark as an ordinary user, open a terminal in template-monitor and run
1. `sudo dpkg-reconfigure wireshark-common`.
2. Answer `Yes` to the question, "should non-superusers be able to capture packets?"
3. Run `sudo usermod -a -G wireshark user`.
4. Shut down the template.

Next time you start a qube using the template-monitor template, you will be able to run Wireshark as an ordinary user.


## Usage
sys-monitor is created with `provides_network` set, so you can attach qubes to it, setting it as netvm.
Wireshark, suricata, tcpdump, and tcpflow are installed and ready to run.
For wireshark see the note above about running as an ordinary user - useful if you want to start from the Q Menu.

As with all Debian templates, services are masked in the template.
This is done in `create.sls`
The suricata service is *unmasked* in the qube, by an entry in `/rw/config/rc.local` which is created in `config.sls`.
This means that you can simply run `sudo systemctl start suricata` to have suricata running with default settings.
Alternatively you can start the service with a custom configuration, as you will.

By default sys-monitor has sys-net as netvm, but you can change this if you wish.
You can monitor traffic at eth0 or at any of the vif interfaces to downstream qubes.

You can, of course, use template-monitor to create other qubes for monitoring at different positions in the Qubes networking structure..

**Remember that Qubes uses masquerade in the nft qubes table, so that all traffic coming from (e.g) sys-firewall appears to come from the IP address of that qube.
If you want to see traffic from individual qubes you must attache those qubes directly to sys-monitor**

## Installation
Copy the monitor folder to /srv/salt.
```
qubesctl state.apply monitor.create
qubesctl --skip-dom0 --targets=template-monitor state.apply monitor.install
qubesctl --skip-dom0 --targets=sys-monitor state.apply monitor.configure
```
### Template creation
Clone the debian-12-minimal template - note the use of `qvm.template_installed` which will install the template if it is not already present
```
sudo qubesctl state.apply monitor.clone
```
`clone.sls` uses `qvm.features` to set the menu. Note that you can do this *before* the relevant packages are installed.

### Qube creation
`create.sls` is a standard way of creating `sys-monitor` - qvm.present is used to create the qube, and preferences and features are set.

Note the use of an `include` statement at the head of the file. This allows a single state execution to call other states.
So `qubesctl state.apply monitor.create` will call and run `monitor.clone`.


### Package installation
```
sudo qubesctl --skip-dom0 --targets=template-monitor state.apply monitor.install

```
This state uses `pkg.installed` to install necessary packages in the template.
Note the use of `pillar.get` to check if a caching proxy is present: the necessary changes to repository definitions are made using `file.replace` within a jinja command structure.

### Configuration
```
sudo qubesctl --skip-dom0 --targets=sys-monitor state.apply monitor.configure
```
This state uses `file.append` to make sure that the suricata service is unmasked in the qube.
The command is run from /rw/config/rc.local: file.append` is used to alter that file.
`file.append` will only add the text if it is not already present.
