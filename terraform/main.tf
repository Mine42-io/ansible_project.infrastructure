terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "2.6.5"
        }
    }
}


variable "pm_0_user" {
    description = "ProxmoxVE user (e.g. root@pam)"
    type = string
    sensitive = false
}


variable "pm_1_password" {
    description = "ProxmoxVE password"
    type = string
    sensitive = true
}


provider "proxmox" {
    pm_api_url = "https://127.0.0.1:8006/api2/json"
    pm_user = var.pm_0_user
    pm_password = var.pm_1_password
    pm_tls_insecure = true
}


resource "proxmox_vm_qemu" "gate" {
    name = "gate"
    target_node = "proxmox-01"
    clone = "ubuntu-20.04-cloudinit"
    os_type = "cloud-init"

    cores = 1
    sockets = 1
    memory = 512
    disk {
      type = "scsi"
      storage = "local"
      size = "4G"
    }

    ciuser = "ansctl"
    cipassword = "ansctl" # Not a problem => Password authentication will be locked during Ansible setup
    ipconfig0 = "ip=10.0.0.101/18,gw=10.0.0.2"
    sshkeys = file("~/.ssh/ansctl-mine42.rsa.pub")
    ssh_user = "ansctl"
    ssh_private_key = "value"

    connection {
        type = "ssh"
        user = self.ciuser
        password = self.cipassword
        host = "10.0.0.101"
        bastion_host = "proxmox-01.mine42.com"
        bastion_user = "ansctl"
        bastion_private_key = file("~/.ssh/ansctl-mine42.rsa")
    }

    provisioner "remote-exec" {
        inline = [
            "ip a"
        ]
    }
}
