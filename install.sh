#!/bin/bash

BASE_PACKAGES="void-repo-nonfree git base-devel bind-utils net-tools nano lm_sensors wget curl xdg-user-dirs bsdtar dbus dbus-devel elogind alsa-tools alsa-utils mtpfs gvfs gvfs-mtp libconfig libconfig-devel mesa-vulkan-intel"
DEV_PACKAGES="meson ninja cmake glib-devel"

AWESOMEWM_DEPS="cairo-devel lgi libxcb-devel libxkbcommon-devel libxdg-basedir-devel gdk-pixbuf-devel xcb-util-cursor-devel xcb-util-keysyms-devel xcb-util-wm-devel xcb-util-xrm-devel"
VLANG_DEPS="libXcursor-devel libXi-devel"

FONTS="ttf-opensans unicode-emoji noto-fonts-emoji fonts-roboto-ttf font-material-design-icons-ttf"

XORG="xorg-minimal xinput xorg-fonts noto-fonts-ttf libXrandr-devel"
POST_INSTALL="ImageMagick NetworkManager network-manager-applet lightdm lxappearance parcellite rofi"
EXTRA_PACKAGES="ocs-url feh flatpak htop btop neofetch geany maim"

install_awesomewm() {
	cd $HOME/repos
	git clone https://github.com/awesomeWM/awesome
	mkdir -p build
	cd build
	cmake .. \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DSYSCONFDIR=/etc
	make -j$(nproc)
	make install
	install -Dm644 ../awesome.desktop \
		"$pkgdir/usr/share/xsessions/awesome.desktop"
}

install_doas() {
	xbps-install -S opendoas
	echo "permit persist :wheel" >> /etc/doas.conf
	echo "permit nopass root" >> /etc/doas.conf
	echo "permit nopass :wheel cmd poweroff" >> /etc/doas.conf
	echo "permit nopass :wheel cmd reboot" >> /etc/doas.conf
}

install_libxnvctrl() {
	cd $HOME/repos
	git clone https://github.com/NVIDIA/nvidia-settings
	cd nvidia-settings
	make
	install -Dm 644 src/libXNVCtrl/*.h -t "/usr/include/NVCtrl"
	cp -Pr src/out/libXNVCtrl.* -t "/usr/lib"
}

install_vibrantcli() {
	install_libxnvctrl
	
	cd $HOME/repos
	git clone https://github.com/libvibrant/libvibrant
	cd libvibrant
	mkdir build
	cd build
	cmake ..
	make
	make install
}

isv() {
	ln -s /etc/sv/$1 /var/service	
}

install_services() {
	isv dbus
	isv elogind
	isv udevd
	isv NetworkManager
	isv dhcpcd
}

sudo su

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

mkdir -p $HOME/repos

install_awesomewm
install_doas
install_vibrantcli
install_services

xbps-install -S $BASE_PACKAGES $DEV_PACKAGES
