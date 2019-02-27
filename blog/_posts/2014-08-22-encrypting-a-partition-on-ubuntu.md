---
title: Encrypting a partition on Ubuntu
date: 2014-08-22T10:00:19+00:00
author: RemyG
layout: rg-post
categories: Ops
tags:
  - backup
  - storage
  - cryptsetup
  - dm-crypt
  - encryption
  - Ubuntu
---

I've decided to implement a better back-up strategy for all my important data.

I'll come back later about the back-up itself, but for now I'll explain what I use to keep the personal stuff (documents,...) private. This means encryption!

<!--more-->

I plan on mainly keeping using Ubuntu (or Ubuntu variants) in the future, and maybe having a Windows installation for the non-Linux games. So the encryption solution compatibility is not an issue for me. That's why I've started by looking for "encrypt hard drive ubuntu" on Duckduckgo, which led me to the [Ubuntu documentation][1]. From there I've found a link to the ArchLinux documentation on [dm-crypt][2].

> dm-crypt is a transparent disk encryption subsystem in Linux kernel versions 2.6 and later and in DragonFly BSD. It is part of the device mapper infrastructure, and uses cryptographic routines from the kernel's Crypto API.

This means that the encryption API is included in the kernel itself (which is a good sign for compatibility and maintenance). But to be able to create and activate encrypted volumes, we need a front-end, and in my case I'll use [cryptsetup][3]. The main cryptsetup commands have changed between versions 1.4.1 (default on Ubuntu 12.04) and 1.6.1 (default on Ubuntu 14.04). For each cryptsetup command, I'll give both versions.

Here is the workflow I use to create my encrypted partitions:

## Create the partition using GParted

I'm a bit lazy, so I prefer to use GParted to create my basic partitions. You can easily find a good documentation about how to create a partition using GParted.

The partition I'll be using is an ext3 primary partition (the file system probably doesn't matter since we'll override this partition later).

## Wipe the partition

Before we create our encrypted partition, we'll wipe the existing partition with pseudo-random data.

**All the commands have to be run as sudo.**

Start by creating a temporary encrypted container on the partition (sdXY) you want to encrypt:

* 1.4.1:

        # crypsetup create my_container /dev/sdXY

* 1.6.1:

        # cryptsetup open --type plain /dev/sdXY my_container

This will create a container for your partition at `/dev/mapper/my_container`.

Then check the container has been created correctly:

    # fdisk -l
    Disk /dev/mapper/my_container: 1000 MB, 1000277504 bytes
    ...
    Disk /dev/mapper/my_container does not contain a valid partition table

Finally, wipe the container with pseudorandom data:

    # dd if=/dev/zero of=/dev/mapper/container
    dd: writing to ‘/dev/mapper/container’: No space left on device

This step will take a while (in my case, around 2 hours for a 50GB partition on a USB hard drive).

Now you can close your partition before the next step:

* 1.4.1:

        # cryptsetup luksClose my_partition

* 1.6.1:

        # cryptsetup close my_partition

## Encrypting / decrypting the partition

Start by setting the LUKS (Linux Unified Key Setup) headers on your partition:

* 1.4.1 / 1.6.1:

        # cryptsetup -v luksFormat /dev/sdXY

You can use different options instead of `-v` (default). You can find a list [here][4].

Then unlock the partition with the Device Mapper:

* 1.4.1:

        # cryptsetup luksOpen /dev/sdXY my_container

* 1.6.1:

        # cryptsetup open /dev/sdXY my_container

which will create a container at `/dev/mapper/my_container`.

Now create a file system of your choice (this is why I said earlier that the file system didn't matter in GParted). I've decided to create an ext3 partition, but this is up to you:

    # mkfs.ext3 /dev/mapper/my_container

Now you can mount your partition:

* 1.4.1:

        # cryptsetup luksOpen /dev/sdXY my_container
        # mount -t ext3 /dev/mapper/my_container /mnt/my_container

* 1.6.1:

        # cryptsetup open --type luks /dev/sdXY my_container
        # mount -t ext3 /dev/mapper/my_container /mnt/my_container

And then unmount it:

* 1.4.1:

        # umount /mnt/my_container
        # cryptsetup luksClose my_container

* 1.6.1:

        # umount /mnt/my_container
        # cryptsetup close my_container

## Easy access in your file manager

Some file managers (Nautilus, Thunar,...) allow you to unlock and mount your encrypted partitions without using the command line.

In your list of devices, just click on the encrypted partition, like you would do for any other partition.

You will get asked to enter the passphrase, and your encrypted partition will be mounted and ready to use.

***

I hope this will convince you to start using encrypted partitions for your personal and private data. It's really easy to do, and can be very useful if your laptop, USB drive,... gets stolen.

I'll come back soon to explain my back-up process.

[1]: https://help.ubuntu.com/community/EncryptedFilesystems "EncryptedFilesystems - Community Help Wiki"
[2]: https://wiki.archlinux.org/index.php/Dm-crypt "dm-crypt - ArchWiki"
[3]: https://code.google.com/p/cryptsetup/ "cryptsetup - Setup virtual encryption devices under dm-crypt Linux - Google Project Hosting"
[4]: https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#Encryption_options_for_LUKS_mode "dm-crypt/Device encryption - Encryption options for LUKS mode - ArchWiki"
