#!/usr/bin/env bash

#Skrypt do uruchomienia po stronie serwera Proxmox
#v.0.1 - wersja nieinteraktywna

apt-get install -y libguestfs-tools
cd /var/lib/vz/template/iso/
wget http://cdimage.debian.org/images/cloud/bullseye/20230124-1270/debian-11-generic-amd64-20230124-1270.qcow2
virt-customize -a debian-11-generic-amd64-20230124-1270.qcow2 --install qemu-guest-agent
qm create 9000 -name debian-cloudinit-template -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1
qm importdisk 9000 debian-11-generic-amd64-20230124-1270.qcow2 local-lvm
qm set 9000 -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-9000-disk-0
qm set 9000 -serial0 socket
qm set 9000 -boot c -bootdisk virtio0
qm set 9000 -agent 1
qm set 9000 -hotplug disk,network,usb
qm set 9000 -vcpus 1
qm set 9000 -vga qxl
qm set 9000 -ide2 local-lvm:cloudinit
#qm resize 9000 virtio0 +8G
qm template 9000