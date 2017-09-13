---
title: My backup strategy
date: 2014-08-25T10:00:13+00:00
author: RemyG
layout: rg-post
categories: System
tags:
  - backup
  - storage
  - rsync
  - SpiderOak
---

I've been using multiple hard drives for around 15 years, since our 2nd familial computer. But it's always been a case of filling up a drive, then buying a new one to store new stuff on it, and so on.

Recently, I've realized (better late than never), that it would be a good idea to back up some of my data. Over the years, I've lost some important files, pictures,... Sometimes, a hard drive just crashed, other times it was a stupid case of "There is probably nothing important on this drive, let's format it!". But all these cases could have easily been prevented if I just had backed up my important stuff, using my up-to 4 internal and 2 external hard drives (yes, I'm a data hoarder...).

That's why I've decided to implement a real backup process; so far, I'm only using it for my important documents and my pictures, but I intend to extend it to other files as I go along.

<!--more-->

## Pictures

This is the easiest process of the two. I always have 3 copies of all my pictures:

* 1 on my laptop (the original one), in `/media/laptop_hdd/Pictures`
* 2 on 2 different USB hard drives (the copies) in `/media/backup_hdd1/Pics` and `/media/backup_hdd2/Pics`

My 2 external hard drives are partitioned to have each a dedicated backup partition of 250GB (this is currently enough, when available space becomes an issue, I'll upgrade to new disks).

Every time I come back home after taking pictures, I immediately transfer them from the camera to my laptop (and I keep them on the camera for now). Once the transfer is done, I plug-in my first USB drive, and copy the pictures using `rsync`:

    $ rsync -av /media/laptop_hdd/Pictures/ /media/backup_hdd1/Pics/

This will copy the content of the folder `Pictures` from my laptop into the folder `Pics` from the backup partition of my first USB drive.

A few notes on this `rsync` syntax:

* `-a` means that the files are transferred in "archive" mode, which ensures that symbolic links, devices, attributes, permissions, ownerships,... are preserved in the transfer
* `-v` means "verbose" (a log of the operation is displayed)
* the trailing slash at the end of the first path (`/media/laptop_hdd/Pictures/`) is very important. If you don't set it, `rsync` will copy `Pictures` inside `Pics`, instead of copying **the content** of `Pictures` inside `Pics` (you'll get your copy in `/media/backup_hdd1/Pics/Pictures` instead of `/media/backup_hdd1/Pics/`). The trailing slash at the end of the second path doesn't matter.

This command won't delete from the backup pictures that were deleted from the source (you can force this behaviour with the parameter `--delete`).

Once the copy is done, I repeat it on my second USB drive:

    $ rsync -av /media/laptop_hdd/Pictures/ /media/backup_hdd2/Pics/

And here I am, with 3 copies of my pictures!

In the future, I'll probably invest in a NAS, with at least 2 drives in RAID (RAID 1 for 2 disks, RAID 10 if I decide to invest in a 4+ disks solution). This would allow me to automatize the backup (since the NAS is always on and connected, I wouldn't have to connect the drives and run the commands manually) and simplify it (just 1 copy from my computer, the NAS would handle the replication on its drives).

## Documents

This part of my backup is more evolved. Ideally, I always have 4 copies of all my documents:

* 1 on my laptop (the original one), in `~/Documents/Important` (the `Documents` directory itself is not backed up, only the `Important` directory)
* 2 on 2 different USB hard drives (the copies) in encrypted partitions
* 1 on SpiderOak

### Encrypted partitions

I've explained in a previous post how to create encrypted partitions on an external hard drive. You can find the instructions [here][enc-part].

My 2 external hard drives are partitioned to have each a dedicated encrypted backup partition of 50GB.

Once I've mounted the encrypted partitions, I just run the same `rsync` command to copy my documents to both encrypted partitions:

    $ rsync -av ~/Documents/Important/ /mnt/private_hdd1/Documents/
    $ rsync -av ~/Documents/Important/ /mnt/private_hdd2/Documents/

Then I can unmount the encrypted partitions, my documents are safely stored on my encrypted partitions.

### SpiderOak

[SpiderOak][spideroak] is exactly like DropBox, except:

* Condoleezza Rice is not a board member
* all my files are encrypted on my computer, before they are transferred to the SpiderOak servers, which means that the company never sees a readable version of them
* Edward Snowden recommends using SpiderOak, and dropping DropBox.

This ensures that my files will be securely stored on the SpiderOak servers. The downside of all that is that if I lose your password, I'll never see my files again (but that's fine, since I already have local backups on my external hard drives).

SpiderOak offers a free account, with the only limitation being the storage space (they offer 2GB, which should be more than enough for my really important documents). The procedure is really simple:

* create an account on their website
* download and install the SpiderOak client on your computer
* configure the client to back up specific folders
* and that's it, your folders will be automatically backed up when a change is made.

Like with DropBox, I can browse my documents with a web-browser, and download them (though they recommend not the web interface, but only the client, for security reasons).

If 2GB is not enough for you, you can always upgrade to a paying account (with really simple pricing rules: 1GB = 1$/year). The paying offers start at 100GB, and go up to more than 1TB.

***

This was a presentation of my backup process. I'm not saying it's the best (far from it, since you always need to have multiple copies at multiple locations, which I don't have for my pictures), but for now it'll have to be enough. As I said before, in the future, I'd like to invest in a NAS (ideally 2, one at home and one somewhere else).

[enc-part]: http://remyg.fr/2014/08/22/encrypting-a-partition-on-ubuntu/ "Encrypting a partition on Ubuntu - RemyG"
[spideroak]: https://spideroak.com/ "SpiderOak | Online File Sharing & Cloud Backup Software | Private & Secure Data Storage for Business"
