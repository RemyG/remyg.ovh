---
layout: rg-post
title: "Mounting a host directory in a Proxmox LXC"
category: "Ops"
tags:
  - Homelab
  - Note
  - Proxmox
excerpt: "How to mount a host directory in a Proxmox LXC"
info: "Homelab note"
---

To mount a host directory in a Proxmox LXC, for example to allow access to a home directory, an USB device, an NFS mount... in the guest:

Create a directory to share on the host (bind mounts *should* be located in `/mnt/bindmounts`):

```shell
mkdir -p /mnt/bindmounts/shared
```

Configure the bind mount on the container (for the container with ID 100): edit `/etc/pve/lxc/100.conf` (on the host) and add:

```shell
mp0: /mnt/bindmounts/shared,mp=/shared
```

Restart the container for the changes to take effect:

```shell
pct restart 100
```

The host directory `/mnt/bindmounts/shared` will be mounted as `/shared` in the LXC.

---

Reference: [Proxmox Documentation - Linux Container - Bind Mount Points](https://pve.proxmox.com/wiki/Linux_Container#_bind_mount_points)