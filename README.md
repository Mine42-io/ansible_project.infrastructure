# Ansible project - `infrastructure`

Manages Mine42 infrastructure.

## Playbooks

### Playbook - `hypervisors.yml`

Manages the hypervisors lifecycle.

#### About ProxmoxVE

ProxmoxVE does not allow `root` login through SSH by default. To bootstrap the
PVE host, the following manual operations are required (replace user `ansctl`
and group `admin` with appropriate values):

* Create or edit the Ansible user group:
  `pveum groupadd admin -comment "System Administrators"`
* Edit the Ansible user group:
  `pveum aclmod / -group admin -role Administrator`
* Create local Ansible user (PAM): `adduser ansctl`
* Add the local Ansible user to its group:
  `pveum usermod ansctl@pam -group admin`

By default, Proxmox does not offers `sudo` and using `su` is buggy when using
an SSH key to login with Ansible. Thus, initial setup requires either:

* To specify `ansible_become_method: su`
* To install `sudo` manually before the first connection

### Playbook - `gates.yml`

Manages infrastructure access gates (jump hosts).

### Playbook - `home.yml`

Manages homes infrastructure.
