setfont sun12x22

nmcli device wifi list
nmcli device wifi connect Tenda_404DB0 password csye3631
ping baidu.com

echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf
echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch" | sudo tee -a /etc/pacman.conf
sudo pacman -Syy && sudo pacman -S archlinuxcn-keyring

sudo pacman -S ttc-iosevka-slab noto-fonts noto-fonts-cjk noto-fonts-emoji tf-latinmodern-math ttf-inconsolata

sudo pacman -S xorg-server xorg-xrdb xorg-xbacklight
sudo pacman -S xorg-apps xorg-xinit xorg-xrandr xorg-xinput

lspci | grep -e VGA -e 3D
sudo pacman -S xf86-video-intel mesa nvidia-dkms nvidia-utils nvidia-settings

sudo pacman -S wget git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

sudo rm /etc/X11/xorg.conf.d/10-xorg.conf /etc/X11/xorg.conf.d/20-*

yay -S optimus-manager
optimus-manager --switch nvidia
systemctl enable optimus-manager.service
systemctl start optimus-manager.service
optimus-manager --switch nvidia
cat /etc/X11/xorg.conf.d/10-optimus-manager.conf 
systemctl status optimus-manager.service

sudo mkdir /etc/pacman.d/hooks
sudo touch /etc/pacman.d/hooks/nvidia.hook
cat > /etc/pacman.d/hooks/nvidia.hook << EOF
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia-dkms
Target=linux-lts
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux-lts) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

sudo pacman -S acpi_call-lts

sudo touch /etc/optimus-manager/optimus-manager.conf
cat > /etc/optimus-manager/optimus-manager.conf << EOF
[optimus]
switching=acpi_call
pci_power_control=no
pci_remove=no
pci_reset=no
EOF

sudo pacman -S i3 rxvt-unicode rofi conky
sudo pacman -S lightdm lightdm-gtk-greeter
# printf '\e]710;%s\007' "xft:Iosevka:size=12:style=Regular"
touch ~/.Xdefaults
cat > ~/.Xdefaults << EOF
!!$HOME/.Xdefaults

Xft.dpi:200

URxvt.preeditType:Root
URxvt.inputMethod:ibus
URxvt.depth:32

URxvt.title:Terminal
URxvt.background:[70]#000000
URxvt.foreground:#00FF00
URxvt.colorBD:Gray95
URxvt.colorUL:Green
URxvt.color1:Red2
URxvt.color4:RoyalBlue
URxvt.color5:Magenta2
URxvt.color8:Gray50
URxvt.color10:Green2
URxvt.color12:DodgerBlue
URxvt.color14:Cyan2
URxvt.color15:Gray95
URxvt.urlLauncher:chromium-browser
URxvt.matcher.button:1
Urxvt.perl-ext-common:matcher
URxvt.scrollBar:True
URxvt.scrollBar_right:True
URxvt.scrollBar_floating:False
URxvt.scrollstyle:plain
URxvt.mouseWheelScrollPage:True
URxvt.scrollTtyOutput:False
URxvt.scrollWithBuffer:True
URxvt.scrollTtyKeypress:True
URxvt.cursorBlink:True
URxvt.saveLines:3000
URxvt.borderLess:False

URxvt.font:\
        xft:Iosevka Term Slab:size=12:style=Regular:antialias=true,\
        xft:Source Code Pro:size=12:style=Regular:antialias=true:hinting=true\
	xft:Noto Serif CJK SC:size=12:style=Regular:antialias=False:hinting=False,\
	xft:Noto Serif CJK TC:size=12:style=Regular:antialias=False:hinting=False,\
URxvt.boldFont:\
        xft:Iosevka Term Slab:size=12:style=Bold:antialias=true,\
        xft:Source Code Pro:size=12:style=Bold:antialias=true:hinting=true\
	xft:Noto Serif CJK SC:size=12:style=Bold:antialias=False:hinting=False,\
	xft:Noto Serif CJK TC:size=12:style=Bold:antialias=False:hinting=False,\
EOF

xrdb -load ~/.Xdefaults

touch ~/.Xresources 
cat > ~/.Xresources << EOF
Xft.dpi: 200
Xft.autohint: 0
Xtf.lcdfilter: lcddefault
Xft.hintstyle: hintfull
xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rga

*background: #1D1F21
*foreground: #C5C8C6
! black
*color0: #282A2E
*color8: #373B41
! red
*color1: #A54242
*color9: #CC6666
! green
*color2: #8C9440
*color10: #B5BD68
! yellow
*color3: #DE935F
*color11: #F0C674
! blue
*color4: #5F819D
*color12: #81A2BE
! magenta
*color5: #85678F
*color13: #B294BB
! cyan
*color6: #5E8D87
*color14: #8ABEB7
! white
*color7: #707880
*color15: #C5C8C6
EOF

xrdb -load ~/.Xresources

sudo systemctl enable lightdm
sudo systemctl start lightdm
cat ~/.config/i3/config 

sudo pacman -S alsa-utils
aplay -L | grep :CARD

sudo pacman -S fcitx-lilydjwg-git fcitx-sogoupinyin fcitx-configtool
fcitx
cat > ~/.xprofile << EOF
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF
cat > ~/.config/i3/config << EOF
exec --no-startup-id LANG="zh_CN.UTF-8" fcitx &
EOF

sudo pacman -S network-manager-applet networkmanager-l2tp networkmanager-pptp

sudo pacman -S bluez bluez-utils blueman 
systemctl start bluetooth.service
systemctl enable bluetooth.service
echo "AutoEnable=true" | sudo tee -a /etc/bluetooth/main.conf
sed -i 's/# DiscoverableTimeout = 180/DiscoverableTimeout = 0\nDiscoverable=true/g' /etc/bluetooth/main.conf
sed -i 's/# PairableTimeout = 0/PairableTimeout = 0\nPairable=true/g' /etc/bluetooth/main.conf

blueman-applet
blueman-manager

sudo pacman -S unzip chromium rsync shadowsocks-libev ranger openssh

sudo pacman -S docker
systemctl enable docker.service
systemctl start docker.service
