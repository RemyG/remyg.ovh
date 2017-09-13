---
id: 773
title: Monitoring a cluster of Raspberry Pi with Nagios
date: 2017-08-01T23:00:55+00:00
author: RemyG
layout: rg-post
permalink: /2017/08/01/monitoring-a-cluster-of-raspberry-pi-with-nagios/
categories: System
tags:
  - cluster
  - nagios
  - raspberry
---
In this post, I'll describe how I've set up the monitoring of my micro-cluster of Raspberry Pi with Nagios.

<img src="http://remyg.fr/blog/wp-content/uploads/2017/08/cluster.png" alt="" width="451" height="219" class="aligncenter size-full wp-image-786" />

<!--more-->

## On the monitor host

Install and configure Nagios: see [this article](https://community.spiceworks.com/how_to/68159-install-nagios-on-a-raspberry-pi)

Install the NRPE plugin:

```
sudo apt-get install nagios-nrpe-plugin
```

Define the services: edit /etc/nagios3/conf.d/services_nagios2.cfg

```
# NRPE Services
define service {
        hostgroup_name                  rpi-cluster
        service_description             Current-Users-N$
        check_command                   check_nrpe_1arg$
        use                             generic-service
        notification_interval           0
}

define service {
    hostgroup_name rpi-cluster
    service_description Current Load NRPE
    check_command check_nrpe_1arg!check_load
    use generic-service
    notification_interval 0
}

define service {
    hostgroup_name rpi-cluster
    service_description Disk Space NRPE
    check_command check_nrpe_1arg!check_all_disks
    use generic-service
    notification_interval 0
}

define service {
    hostgroup_name rpi-cluster
    service_description Zombie Processes NRPE
    check_command check_nrpe_1arg!check_zombie_procs
    use generic-service
    notification_interval 0
}

define service {
    hostgroup_name rpi-cluster
    service_description Total Processes NRPE
    check_command check_nrpe_1arg!check_total_procs
    use generic-service
    notification_interval 0
}

define service {
    hostgroup_name rpi-cluster
    service_description Swap NRPE
    check_command check_nrpe_1arg!check_swap
    use generic-service
    notification_interval 0
}

```

Define the new hostgroup: /etc/nagios3/conf.d/hostgroups_nagios2.cfg

```
define hostgroup {
        hostgroup_name  rpi-cluster
                alias           Raspberry PI Cluster
                members         rpi0,rpi1,rpi2
        }
```

Define a new host file for each slave: /etc/nagios3/conf.d/rpi-cluster-xxx.cfg. The address config contains the slave IP.

```
define host {
        use                     generic-host
        host_name               rpixxx
        alias                   rpi-cluster-xxx
        hostgroups              rpi-cluster
        address                 192.168.0.xxx
}

```

Reload Nagios:

```
sudo service nagios3 reload
```

## On the slave hosts

Install the NRPE server:

```
sudo apt-get install nagios-nrpe-server
```

Edit /etc/nagios/nrpe_local.cfg. The ```allowed_hosts``` config contains the IP of the monitor.

```
######################################
# Do any local nrpe configuration here
######################################

allowed_hosts=127.0.0.1,192.168.0.xxx

command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10
command[check_load]=/usr/lib/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
command[check_all_disks]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10%
command[check_zombie_procs]=/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z
command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 150 -c 200
command[check_swap]=/usr/lib/nagios/plugins/check_swap -w 50% -c 25%
```

Restart the service:

```
sudo service nagios-nrpe-server restart
```

## Monitor

You can now monitor the slaves on Nagios:

<img src="http://remyg.fr/blog/wp-content/uploads/2017/08/nagios.png" alt="" width="513" height="156" class="aligncenter size-full wp-image-789" />

***

Inspired by: [LowEndBox](https://lowendbox.com/blog/remote-server-monitoring-with-nagios/)
