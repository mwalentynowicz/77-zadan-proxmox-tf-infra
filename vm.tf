resource "proxmox_vm_qemu" "ansible_vms" {
  #todo:
  # 6. Skrypt do parametryzacji kodu terraforma

  count = "5"

  #Proxmox settings
  vmid = "101" + count.index
  name = var.ansible_vm[count.index].fqdn
  target_node = "pve"

  #vm template
  clone = "ubuntu-cloudinit-template"
  os_type = "cloudinit"

  # Cloud init options
  ciuser = "ansible"
  cipassword = "ansible"

  sshkeys = file("${path.module}/ssh_keys/id_rsa.pub")
  ipconfig0 = "ip=${var.ansible_vm[count.index].ip}/24,gw=192.168.1.1"

  memory       = var.ansible_vm[count.index].ram

  #z powodu, ze obraz ktorego uzywam nie ma zainstalowanego qemu-guest-agenta domyslnie wylaczam poki co te opcje
  agent        = 1
  sockets       = 1
  cores         = 1

  # Set the boot disk paramters
  bootdisk = "scsi0"
  scsihw       = "virtio-scsi-pci"

  disk {
    #id              = 0
    size            = "10G"
    type            = "scsi"
    storage         = "local-lvm"
    #storage_type    = "lvm"
    #iothread        = true
  }

  # Set the network
  network {
    #id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  connection {
    type        = "ssh"
    user        = "ansible"
    host        = var.ansible_vm[count.index].ip
    #password    = "ansible"
    private_key = file("${path.module}/ssh_keys/id_rsa")
    port        = "22"
  }

  #files are provisioning with ansible owner and 644 privileges
  provisioner "file" {
    source      = "${path.module}/ssh_keys/fingerprint_ed25519"
    destination = "/tmp/ssh_host_ed25519_key"
  }

  provisioner "file" {
    source      = "${path.module}/ssh_keys/fingerprint_ed25519.pub"
    destination = "/tmp/ssh_host_ed25519_key.pub"
  }

  provisioner "file" {
    source      = "${path.module}/ssh_keys/fingerprint_rsa"
    destination = "/tmp/ssh_host_rsa_key"
  }

  provisioner "file" {
    source      = "${path.module}/ssh_keys/fingerprint_rsa.pub"
    destination = "/tmp/ssh_host_rsa_key.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname ${var.ansible_vm[count.index].fqdn}",
      "sudo mv /tmp/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub",
      "sudo mv /tmp/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key",
      "sudo mv /tmp/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub",
      "sudo mv /tmp/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key",
      "sudo chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ed25519_key",
      "sudo chmod 644 /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_ed25519_key.pub",
      "sudo chown root /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_ed25519_key.pub",
     ]
  }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
     ignore_changes = [
       network
     ]
  }
}

