vm_template_id = 1001
vm_template_node = "SmittyNet-PVE-1"

hosts = {
  runamuck = {
    node          = "SmittyNet-PVE-1"
    vmid          = 112
    name          = "runamuck"
    cpu_cores     = 2
    memory_mb     = 4096
    disk_gb       = 20
    datastore     = "local-lvm"
    bridge        = "vmbr0"
    ipv4_cidr     = "192.168.3.21/24"
    ipv4_gw       = "192.168.3.1"
    ansible_user  = "ubuntu"
    groups        = ["linux", "samba_dc"]
  }

    runabout = {
    node          = "SmittyNet-PVE-2"
    vmid          = 212
    name          = "runabout"
    cpu_cores     = 2
    memory_mb     = 4096
    disk_gb       = 20
    datastore     = "local-lvm"
    bridge        = "vmbr0"
    ipv4_cidr     = "192.168.3.22/24"
    ipv4_gw       = "192.168.3.1"
    ansible_user  = "ubuntu"
    groups        = ["linux", "samba_dc"]
  }
}