---
layout: rg-post
title: "Setting up a fixed IP in a Debian VM"
category: "Ops"
tags:
  - Note
  - Debian
  - Proxmox
excerpt: "How to set a fixed IP on a Debian VM in Proxmox"
info: "Homelab note"
---

To assign a fixed IP to a Debian VM in Proxmox:

Update the file `/etc/netplan/50-cloud-init.yaml` from

```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: yes
```

to

```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses: [192.168.x.x/24]
      routes:
        - to: default
          via: 192.168.x.1
```

Then restart the network interface:

```shell
ifdown ens18
ifup ens18
```