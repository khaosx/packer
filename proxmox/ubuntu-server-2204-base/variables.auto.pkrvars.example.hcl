# Variable file for creating Ubuntu 22.04 template on Proxmox
#
# DO NOT COMMIT TO GIT
# Remove "example" from the file name to activate.
#
#
# Variable Definitions

# Proxmox Connection values
proxmox_api_url = "https://your-proxmox-url:port/api2/json"
proxmox_api_token_id = "your-token-id"  # API Token ID
proxmox_api_token_secret = "your-token-secret"
proxmox_api_skip_tls = "false"  # Set to true if you are using self-signed certificates
proxmox_api_node = "your-proxmox-node"

# VM General Settings

vm_general_vmid = "your-vm-id"
vm_general_template_name = "Your-Template-Name"
vm_general_template_description = "Your Template Description"
vm_general_tags = "tag1;tag2"
vm_general_machine_type = "machine-type"
vm_general_bios_type = "bios-type"

# VM System Settings
install_qemu_agent = true

# VM Boot Settings
vm_boot_iso_storage_pool = "iso-storage-pool:iso"
vm_boot_ubuntu_image = "your-ubuntu-image.iso"
vm_boot_ubuntu_image_checksum = "checksum-value"
vm_storage_pool = "your-storage-pool"
vm_disk_size = "16G"
vm_storage_format = "raw"
vm_cpu_core_count = "1"
vm_cpu_type = "host"
vm_memory = "2048"
