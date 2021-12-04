# maxhoesel.pterodactyl.pterodactyl_wings

Install and initialize the pterodactyl wings daemon

This role follows the official installation instructions on the pterodactyl [docs homepage](https://pterodactyl.io/wings/1.0/installing.html).

## Requirements

- The following distributions are currently supported:
  - Ubuntu 18.04 LTS or newer
  - There are no plans to support CentOS/RHEL-based distros right now
- This role requires root access. Make sure to run this role with `become: yes` or equivalent
- Docker is required to run Wings. If docker is not present, this role will install it automatically
- You must have already created a new node in your panel.

## Role Variables

### General

##### `pterodactyl_wings_version`
- Version of wings to install
- Can be a specific tag (e.g. `v1.3.2`) or `latest`
- Default: latest

##### `pterodactyl_wings_config_dir`
- Directory in which the config file is stored
- Default: `/etc/pterodactyl`

##### `pterodactyl_wings_docker_install`
- Whether to handle the docker installation.
- Set to `false` if you already have a docker install running and don't want this role to touch anything
- Default: `true`

##### `pterodactyl_wings_docker_source`
- Method used to install docker
- If set to `distro`, the Docker version provided by the distribution will be installed
- If set to `stable`, the most recent stable version form the official Docker repositories will be installed
- If this value is changed later, the role will automatically switch the installed Docker version. Note that this may cause downtime
- Default: `stable`

### Wings Configuration

Prefix for all variables: `pterodactyl_wings_`

| Name | Description | Required | Default |
|------|-------------|:--------:|---------|
| `remote` | Full URL of the panel instance (including http(s):// and port) | | `"https://127.0.0.1:443"` |
| `uuid` | UUID assigned to the node by the panel | X | not set |
| `token_id` | ID of the token assigned to the node by the panel | X | not set |
| `token` | Token assigned to the node by the panel | X | not set |
| `port` | Port on which the daemon will listen for requests |  | 8080 |
| `ssl_cert` | SSL certificate file for the daemon. Must already be present | | `"/etc/letsencrypt/live/{{ ansible_fqdn }}/fullchain.pem"` |
| `ssl_key` | SSL key file for the daemon. Must already be present | | `"/etc/letsencrypt/live/{{ ansible_fqdn }}/privkey.pem"` |
| `data_dir` | Directory under which the servers will be stored | | `/var/lib/pterodactyl/volumes`
| `upload_limit` | Maximum file upload size in MB | | 100 |
| `sftp_port` | Port on which the SFTP server will listen on | | 2022 |
| `allowed_mounts` | Allowed mounts on this node as configured in the panel | | `[]` |

## Example Playbooks

```
# Performs a basic wings installation
# such as ansible-vault or via vars-prompt
- hosts: all
  roles:
    - role: maxhoesel.pterodactyl.pterodactyl_wings
      become: yes
      vars:
        pterodactyl_wings_remote: https://mypanel.example.com:443
        # Get these values from your panel
        pterodactyl_wings_uuid: 12544f88-cfbf-40b6-9432-a2bc14312112
        pterodactyl_wings_token_id: m9TVwtaw6FQQZt8H
        pterodactyl_wings_token: dPigfaWa4I4xcY3o5sM3Hi3ST3duxHqCqu30fc3eO44lPj7msGY6R14YKCR6QZJ2
```
