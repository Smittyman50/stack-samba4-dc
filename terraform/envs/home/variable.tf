variable "environment" {
  type    = string
  default = "home"
}

variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint, e.g. https://pve01:8006"
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API token (user@realm!tokenid=secret)"
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Allow self-signed TLS for Proxmox API"
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key injected via cloud-init"
}

variable "vm_template_id" {
  type        = number
  description = "Proxmox VM ID of the cloud-init template to clone"
}

variable "vm_template_node" {
  type        = string
  description = "Proxmox node where the source template VM resides"
}

# A simple host spec list
variable "hosts" {
  type = map(object({
    node        = string
    vmid        = number
    name        = string
    cpu_cores   = number
    memory_mb   = number
    disk_gb     = number
    datastore   = string
    bridge      = string
    vlan        = optional(number)
    ipv4_cidr   = string   # e.g. 192.168.10.50/24
    ipv4_gw     = string   # e.g. 192.168.10.1
    ansible_user = string  # e.g. ubuntu
    groups      = list(string)
  }))
}
