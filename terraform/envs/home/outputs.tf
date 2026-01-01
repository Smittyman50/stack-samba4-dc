output "hosts" {
  description = "Host inventory data for Ansible inventory generation"
  value       = module.vm_fleet.hosts
}

output "vm_ids" {
  description = "Map of inventory hostname => Proxmox VM ID"
  value       = module.vm_fleet.vm_ids
}
