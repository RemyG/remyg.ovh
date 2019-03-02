---
title: Update your Nikon DSLR firmware on Ubuntu
date: 2015-12-28T10:50:46+00:00
update-date: 2019-03-01T20:00:00+00:00
author: RemyG
layout: rg-post
categories: Photography
tags:
  - Nikon
  - D750
  - Linux
---

I've just invested in a new DSLR, a Nikon D750. One of the first things I do after unboxing it, is to update its firmware to the latest version, to have the latest functionalities and fixes.

Ubuntu (and other Linux distributions) is, as often, forgotten by these major manufacturers, who only provide Windows and Mac OS solutions.

<!--more-->

To update the firmware on a Linux distribution:

- download the Windows updater (F-D750-V115W.exe) from the Nikon [download center](https://downloadcenter.nikonimglib.com/en/download/fw/318.html)
- extract the content of the exe file, which is actually a rar archive:  
```unrar e F-D750-V115W.exe```
- copy the content of the archive (D750_0115.bin) on an SD card, and put it in the slot 1 of your camera
- in the Setup menu of your camera, select "Firmware version" and follow the on-screen instructions to complete the firmware update
- once the update is complete, turn the camera off and remove the card
- delete the bin file from your card

And voilà, your Nikon DSLR has the latest firmware!

**Changelog:** 2019-03-01 - Latest firmware version