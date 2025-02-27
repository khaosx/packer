# ---
# Packer Template to create an Ubuntu Server (22.04) on Proxmox

packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  vm_boot_iso_file = "${var.vm_boot_iso_storage_pool}/${var.vm_boot_ubuntu_image}"
}

# Resource Definition for the VM Template
source "proxmox-iso" "ubuntu-server-2404" {
    proxmox_url = var.proxmox_api_url
    username = var.proxmox_api_token_id
    token = var.proxmox_api_token_secret
    insecure_skip_tls_verify = var.proxmox_api_skip_tls
    node = var.proxmox_api_node

    # VM General Settings
    vm_id = var.vm_general_vmid
    vm_name = var.vm_general_template_name
    template_description = var.vm_general_template_description
    tags = var.vm_general_tags
    machine = var.vm_general_machine_type
    bios = var.vm_general_bios_type

    # VM System Settings
    qemu_agent = var.install_qemu_agent

    # VM Boot Settings
    boot_iso {
      type = "scsi"
      iso_file = local.vm_boot_iso_file
      unmount = true
      iso_checksum = var.vm_boot_ubuntu_image_checksum
    }

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = var.vm_disk_size
        format = var.vm_storage_format
        storage_pool = var.vm_storage_pool
        type = "virtio"
    }

    efi_config {
      efi_storage_pool = var.vm_storage_pool
      pre_enrolled_keys = true
    }

    # VM CPU Settings
    cores = var.vm_cpu_core_count
    cpu_type = var.vm_cpu_type

    # VM Memory Settings
    memory = var.vm_memory

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr10"
        firewall = "false"
    }

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "vm-disks"
    cloud_init_disk_type = "scsi"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http"
    # (Optional) Bind IP Address and Port
    http_bind_address = "10.0.10.44"
    http_port_min = 8802
    http_port_max = 8802

    ssh_username = "jarvis"
    ssh_private_key_file = "~/.ssh/jarvis_ed25519"
    ssh_timeout = "10m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-2404"
    sources = ["proxmox-iso.ubuntu-server-2404"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Add additional provisioning scripts here
    # ...
}