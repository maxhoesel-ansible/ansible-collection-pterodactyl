# maxhoesel.pterodactyl

![Release](https://img.shields.io/github/v/release/maxhoesel/ansible-collection-pterodactyl)
![CI Status (Roles)](https://img.shields.io/github/workflow/status/maxhoesel/ansible-collection-pterodactyl/CI%20Roles/main)
![License](https://img.shields.io/github/license/maxhoesel/ansible-collection-pterodactyl)

---
**NOTE**

This collection is still under active development and do not have an official stable release yet.
Breaking changes may occur between minor releases (e.g. 0.2 -> 0.3) if needed.

---

An Ansible collection to manage Pterodactyl Panel and Wings servers. This collection targets the 1.0
series of Pterodactyl software. There is no support for older versions (0.7 and before).

The collection currently contains roles for installing both the panel and wings on Ubuntu systems.
Modules for accessing the Pterodactyl API are planned for the future, once a Python API wrapper
for v1.0 becomes available.

## Installation

### Dependencies

- A recent version of ansible. We test against the current and the 2 previous major releases
- Python 3.6 or newer on remote hosts and the controller

### Install via ansible-galaxy

Install this role via ansible-galaxy:

`ansible-galaxy collection install maxhoesel.pterodactyl`

You can also install the most recent version of this collection by referencing this repository.

`ansible-galaxy collection install git+https://github.com/maxhoesel/ansible-collection-pterodactyl`

## Usage

Currently, only two roles are available: `pterodactyl_panel` and `pterodactyl_wings`.
These roles manage installation of the respective component. See their docs for more details.

Let's say you want to deploy a pterodactyl installation with a panel and a few nodes.
In this case, your inventory probably looks a little like this:

```yaml
all:
  children:
    panel:
      panel.my.domain:
    nodes:
      node1.my.domain:
      node2.my.domain:
      node3.my.domain:
      #...
```

### Installing the Panel

First, let's install the panel using the `pterodactyl_panel` role. There's a few things do to first though:

- Make sure that your host meets the requirements of `pterodactyl_panel` (see the roles README for details)
- Create and prepare a MySQL/MariaDB database + user for the panel (you can use another ansible role/collection for this)
- Create and save a SSL certificate to the remote host. You can use Let's Encrypt or create your own self-signed cert (for internal use, make sure that all your hosts trust that cert!)
- (Optional) Configure a SMTP server to accept outgoing mail coming from your panel. This isn't required for internal/testing setups, but still recommended

Finally, we need to generate a valid App Key and HashIDs salt. These cryptographic values are required to setup the panel and should
to be saved in a secure location, such as Ansible Vault. You can generate them on your machine by running these commands:

- App Key: `echo "base64:$(openssl rand -base64 32)"`
- HashIDs Salt: `tr -dc A-Za-z0-9 </dev/urandom | head -c 20 ; echo`

Again, make sure to store these values in a safe and secure place (especially the App Key, as it is used to encrypt/decrypt your panel data!).

Once that's done, you can customize and run the playbook below:

`panel.yml`:
```yaml
- hosts: panel
  tasks:
    - name: Install Pterodactyl Panel
      include_role:
        name: maxhoesel.pterodactyl.pterodactyl_panel
      # pterodactyl_panel supports additional options, see it's README for more details.
      vars:
        pterodactyl_panel_app_key: your-app-key-here
        pterodactyl_panel_hashids_salt: your-salt-here
        # The timezone in which the panel should operate
        pterodactyl_panel_timezone: Europe/Berlin
        # DB settings. Make sure that the database + user already exist and are accessible
        pterodactyl_panel_db_host: "127.0.0.1"
        pterodactyl_panel_db_name: panel
        pterodactyl_panel_db_user: pterodactyl
        pterodactyl_panel_db_password: users-db-password-here
        # Mail server settings.
        pterodactyl_panel_mail_host: smtp.gmail.com
        pterodactyl_panel_mail_user: your-address@gmail.com
        pterodactyl_panel_mail_password: your-mail-password
        pterodactyl_panel_mail_encryption: tls
        # By default, the role will create a user with the credentials admin/admin.
        # You can change these values below or in the UI once the panel is up and running
        pterodactyl_panel_admin_mail: "your-address@gmail.com"
        #pterodactyl_panel_admin_user: admin
        #pterodactyl_panel_admin_password: admin
```

Once the playbook finishes your panel should be reachable under `https://panel.my.domain`.

### Installing Wings

Before you can install the wings daemon on your nodes, you first need to add them to the panel using the UI.
Future releases of this collection will hopefully include modules to access the pterodactyl API to automate this process,
but for now, manual action is required.

Go into the panel, add a location and then add all of your nodes, filling out the required fields.
Once that's done, go to the "Configuration" tab and note down the config options.
Then add the following snippet to the host_vars of each node:

```yaml
pterodactyl_wings_uuid: node-uuid-here
pterodactyl_wings_token_id: node-token-id-here
pterodactyl_wings_token: node-token-here
```

In addition to the panel, the wings daemon also required a SSL cert and key to be present on the remote host.
Again, you can use Let's Encrypt or a self-signed cert for internal use (make sure that all hots trust the cert).

`wings.yml`:
```yaml
- hosts: nodes
  tasks:
    - name: Install Pterodactyl Wings Daemon
      include_role:
        name: maxhoesel.pterodactyl.pterodactyl_wings
      # pterodactyl_wings supports additional options, see it's README for more details.
      vars:
        pterodactyl_wings_remote: "https://panel.my.domain:443"
```

Now, go to your panel and check the node status. It should be online and ready to host servers!

## License & Author

Created & Maintained by Max Hösel (@maxhoesel)

Licensed under the GPL 3.0 or later
