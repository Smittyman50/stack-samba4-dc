module "vm_fleet" {
  # Preferred: pin to an infra-platform tag
  # source = "git::http://gitgard.home.arpa:3000/smittyman/infra-platform.git//terraform/modules/proxmox_vm_fleet?ref=v0.1.0"

  # For local development/testing (if you check out both repos next to each other):
  # source = "../../../infra-platform/terraform/modules/proxmox_vm_fleet"

  source = "git::http://gitgard.home.arpa:3000/smittyman/infra-platform.git//terraform/modules/proxmox_vm_fleet?ref=v0.1.0"

  vm_template_id   = var.vm_template_id
  vm_template_node = var.vm_template_node
  ssh_public_key   = var.ssh_public_key
  hosts            = var.hosts
}
