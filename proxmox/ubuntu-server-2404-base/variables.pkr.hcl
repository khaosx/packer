# Variable Definitions

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "proxmox_api_skip_tls" {
  type = string
  default = false
}

variable "proxmox_api_node" {
  type    = string
  default = "proxmox-01"
}

# VM General Settings

variable "vm_general_vmid" {
  type    = string
  default = "999"
}

variable "vm_general_template_name" {
  type    = string
  default = "Ubuntu-22.04-Template"
}

variable "vm_general_template_description" {
  type    = string
  default = "Ubuntu 22.04 Template"
}

variable "vm_general_tags" {
  type    = string
  default = "ubuntu-2204;template"
}

variable "vm_general_machine_type" {
  type    = string
  default = "q35"
}

variable "vm_general_bios_type" {
  type    = string
  default = "ovmf"
}

# VM System Settings
variable "install_qemu_agent" {
  type    = string
  default = true
}

# VM Boot Settings
variable "vm_boot_iso_storage_pool" {
  type    = string
  default = "pve_syno_iso:iso"
}

variable "vm_boot_ubuntu_image" {
  type    = string
  default = "ubuntu-22.04.5-live-server-amd64.iso"
}

variable "vm_boot_ubuntu_image_checksum" {
  type    = string
  default = "none"
}

variable "vm_storage_pool" {
  type    = string
  default = "vm-disks"
}

variable "vm_disk_size" {
  type    = string
  default = "32G"
}

variable "vm_storage_format" {
  type    = string
  default = "raw"
}

variable "vm_cpu_core_count" {
  type    = string
  default = "1"
}

variable "vm_cpu_type" {
  type    = string
  default = "host"
}

variable "vm_memory" {
  type    = string
  default = "2048"
}
