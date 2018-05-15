```
$ ls /sys/firmware/efi/efivars   # Verify the boot mode
```



```
$ ping www.baidu.com
$ wifi-menu
$ timedatectl set-ntp true
$ vim /etc/pacman.d/mirrorlist
# Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch
$ pacman -Syy
```



```
# 分一个swap (2048M)，一个ESP(260)，剩下给/
$ lsblk
$ fdisk /dev/sda
  g                     # create a new empty GPT partition table
  n
  \r
  First sector 2048 
  Last sector +260M
  n
  \r
  First sector \r 
  Last sector +260M
  n
  \r
  First sector \r 
  Last sector +260M
  n
  \r
  First sector \r 
  Last sector +2048M
  n
  \r
  First sector \r 
  Last sector \r
  w                      # save and exit
$ mkfs.fat -F32 /dev/sda1
$ mkfs.ext4 /dev/sda2 
$ mkswap /dev/sda3
$ swapon /swapfile
$ mkfs.ext4 /dev/sda4

$ mount /dev/sda4 /mnt
$ mkdir /mnt/boot
$ mount /dev/sda2 /mnt/boot
$ mkdir /mnt/boot/EFI
$ mount /dev/sda1 /mnt/boot/EFI

$ lsblk
```



```
$ pacstrap -i /mnt base base-devel
$ genfstab -U /mnt >> /mnt/etc/fstab
$ arch-chroot /mnt /bin/bash
$ pacman -S vim zsh
```



```
$ ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
$ hwclock --systohc --utc
```



```
$ vim /etc/locale.gen    # uncomment en_US.UTF-8 and zh_CN.UTF-8
$ locale-gen
$ echo LANG=en_US.UTF-8 > /etc/locale.conf
```



```
$ echo $hostname > /etc/hostname 
$ vim /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname
```



```
pacman -S networkmanager 
systemctl enable NetworkManager
```



```
$ pacman -S dosfstools grub efibootmgr
$ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --recheck
$ grub-mkconfig -o /boot/grub/grub.cfg
```



```
$ passwd
$ groupadd groutname
$ useradd -m -g <groupname> -s /bin/zsh username
$ passwd username
$ vim /etc/sudoers        # add username ALL=(ALL) ALL
```



```
$ exit
$ umount -R /mnt
$ reboot
```



```
$ systemctl enable dhcpcd
```



```
$ pacman -S xorg-server xorg-apps xorg-xinit
```



```
$ pacman -S ttf-dejavu wqy-microhei
```



```
$ pacman -S i3
$ sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc
$ sudo vim ~/.xinitrc          # add exec i3 in the last line
$ sudo pacman -S xfce4-terminal
$ starx
$ win \r
$ 
```





```
$ sudo vim /etc/pacman.conf    # uncomment multilib
$ sudo pacman -Syy
$ sudo pacman -S teamviewer lib32-dbus
```

