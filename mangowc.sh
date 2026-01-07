#!/bin/sh

# Obligations #

build() {
		echo -e '\033[33mInstalling:

wayland-devel
xwayland-devel
libxcb-devel
lcms2-devel
xcb-util-wm-devel
xcb-util-renderutil-devel
libinput-devel
libdrm-devel
libxkbcommon-devel
pixman-devel
libdisplay-info-devel
libliftoff-devel
hwdata-devel
libseat-devel
pcre2-devel
mesa-devel\033[0m

\033[32mBuilding..\033[0m
	'

	doas apk add wayland-devel xwayland-devel libxcb-devel lcms2-devel xcb-util-wm-devel xcb-util-renderutil-devel libinput-devel libdrm-devel libxkbcommon-devel pixman-devel libdisplay-info-devel libliftoff-devel hwdata-devel libseat-devel pcre2-devel mesa-devel
	cd wlroots
	meson setup build -Dprefix=/usr -Dxwayland=enabled -Dsession=auto -Dbackends=auto -Dexamples=false -Dlibliftoff=enabled -Drenderers=auto -Dallocators=auto -Dcolor-management=enabled
	doas ninja -C build install
	cd scenefx
	meson setup build -Dprefix=/usr
 	doas ninja -C build install
	cd ..
	cd mangowc
	meson setup build -Dprefix=/usr
	doas ninja -C build install
	
	while true; do 
		read -p 'Would you like to remove its dependencies? [Yy/Nn]: ' prompt
		case $prompt in 
			[Yy]* ) doas apk del clang cmake pkgconf ninja meson wayland-devel wayland-protocols xwayland-devel libxcb-devel lcms2-devel xcb-util-wm-devel xcb-util-renderutil-devel libinput-devel libdrm-devel libxkbcommon-devel pixman-devel libdisplay-info-devel libliftoff-devel hwdata-devel libseat-devel pcre2-devel mesa-devel
				###
				doas apk add wayland xwayland libxcb lcms2 xcb-util-wm xcb-util-renderutil libinput libdrm libxkbcommon pixman libdisplay-info libliftoff hwdata libseat pcre2 mesa
				###
				echo -e '\033[33mMangoWC has successfully installed!\033[0m'
				exit 1
				;;
			[Nn]* ) exit 1
				;;
			*) echo -e "\033[31mPlease enter the valid value.\033[0m"
		esac
	done
}

preparation() {
	echo -e '\033[32mGetting its make dependencies...\033[0m'
	echo -e '\033[33mInstalling CMake, Clang, Meson, Ninja, PkgConf and Wayland Protocols!\033[0m'
	doas apk add cmake clang meson ninja pkgconf wayland-protocols
	echo -e '\033[32mChecking if git is installed.\033[0m'
	
	git=$(ls /usr/bin/git)
	if [ "$git" = '/usr/bin/git' ]; then
		echo -e '\033[33m/usr/bin/git has been found!\033[0m'
		git clone -b 0.19.1 https://gitlab.freedesktop.org/wlroots/wlroots
		cd wlroots
		git clone -b 0.4.1 https://github.com/wlrfx/scenefx
		git clone https://github.com/DreamMaoMao/mangowc
		build
	else 
		doas apk add git
		git clone -b 0.19.1 https://gitlab.freedesktop.org/wlroots/wlroots
		cd wlroots
		git clone -b 0.4.1 https://github.com/wlrfx/scenefx
		git clone https://github.com/DreamMaoMao/mangowc
		build
	fi
}

# Check the current distribution that the user is using.
distribution() {
	echo -e '\033[34mChecking the distrubution.\033[0m'
	linux=$(grep 'Chimera Linux' /etc/os-release | awk -F '=' -F '"' ' {print $2} ')
	
	if [ "$linux" = 'Chimera Linux' ]; then
		echo -e '\033[34mChimera Linux has been detected!\033[0m'
		preparation # Calling the function.
	else
		echo -e '\033[31mThis script is meant for Chimera Linux users only!\033[0m'
		exit 1
	fi
}

distribution
