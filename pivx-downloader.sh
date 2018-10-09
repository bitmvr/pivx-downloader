#!/usr/bin/env bash

set -e 

pivxdl::getLatestVersionURL(){
	local url='https://github.com/PIVX-Project/PIVX/releases/latest'
	curl -Ls -o /dev/null -w %{url_effective} "$url"
}

pivxdl::getLatestVersion(){
	pivxdl::getLatestVersionURL | awk -F"/" '{ print $NF}'
}

pivxdl::getMajorVersion(){
	pivxdl::getLatestVersion | tr -d 'v' | awk -F'.' '{ print $1 }'
}

pivxdl::getMinorVersion(){
	pivxdl::getLatestVersion | tr -d 'v' | awk -F'.' '{ print $2 }'
}

pivxdl::getPatchVersion(){
	pivxdl::getPatchVersion | tr -d 'v' |  awk -F'.' '{ print $3 }'
}

pivxdl::urlPrefix() {
	local url_prefix
	url_prefix="pivx-$(pivxdl::getLatestVersion)-"
	echo "$url_prefix"
}

pivxdl::urlSuffix(){
	# Unknown == pivx-3.1.1.tar.gz
	os="$1"
	case "$os" in
	--arch64)
		echo 'aarch64-linux-gnu.tar.gz'
		;;
	--arm32)
		echo 'arm-linux-gnueabihf.tar.gz'
		;;
	--macOS-HighSierra)
		echo 'high-sierra-only.dmg'
		;;
	--linux32)
		echo 'i686-pc-linux-gnu.tar.gz'
		;;
	--linux64)
		echo 'x86_64-linux-gnu.tar.gz'
		;;
	--macOS-tarball)
		echo 'osx64.tar.gz'
		;;
	--MacOS-dmg)
		echo 'osx-unsigned.dmg'
		;;
	--win32-exe)
		echo 'win32-setup-unsigned.exe'
		;;
	--win32-zip)
		echo 'win32.zip'
		;;
	--win64-exe)
		echo 'win64-setup-unsigned.exe'
		;;
	--win64-zip)
		echo 'win64.zip'
		;;
	*)
		echo 'Unknown flag was passed'
		exit 1
		;;
	esac		
}

pivxdl::urlBuilder(){
	desired_os="$1"
	echo "https://github.com/PIVX-Project/PIVX/releases/download/$(pivxdl::getLatestVersion)/$(pivxdl::urlPrefix)$(pivxdl::urlSuffix $desired_os)"
}


pivxdl::usage(){
	echo ""
	echo "pivx-downloader - A small CLI utility to grab the latest version of the PIVX wallet"
	echo ""
	echo -e "\\t--arch64 | Arch 64-bit"
	echo -e "\\t--arm32 | Arm 32-bit"
	echo -e "\\t--macOS-HighSierra | MacOS High Sierra Only DMG"
	echo -e "\\t--linux32 | Linux 32-bit"
	echo -e "\\t--linux64 | Linux 64-bit"
	echo -e "\\t--macOS-tarball | MacOS Tarball"
	echo -e "\\t--MacOS-dmg | MacOS DMG"
	echo -e "\\t--win32-exe | Win32 Installer (Unsigned)"
	echo -e "\\t--win32-zip | Win32 Zip"
	echo -e "\\t--win64-exe | Win64 Installer (Unsigned)"
	echo -e "\\t--win64-zip | Win64 Zip"
	echo ""
}

flag="$1"

case "$flag" in
	--help)
		pivxdl::usage
		;;
	*)
		pivxdl::urlBuilder $flag
		;;
esac

