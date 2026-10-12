Just cross compiling

Sources of information:
=======================
- https://github.com/BPI-SINOVOIP/pi-linux branch linux-6.6.63-k1
- https://github.com/BPI-SINOVOIP/armbian-build/tree/main
Whats not working:
==================

- the kernel is not building, dont know whttps://github.com/BPI-SINOVOIP/pi-linuxhy.


Build:
===== 
```
nix build .
```

Flash:
======
```
sudo dd if=result/sd-image/*.img of=/dev/sdX bs=4M conv=fsync status=progress
```

The SD card carries the whole boot chain in front of the first partition
(same layout as armbian): bootinfo in sector 0, FSBL (U-Boot SPL) at sector 1,
OpenSBI `fw_dynamic.itb` at 640K, `u-boot.itb` at 1M. U-Boot then boots
`/boot/extlinux/extlinux.conf` from the root partition. Serial console is
ttyS0 at 115200.
