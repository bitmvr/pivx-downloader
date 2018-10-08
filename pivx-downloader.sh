#!/usr/bin/env bash


# pivx-3.1.1-aarch64-linux-gnu.tar.gz
# pivx-3.1.1-arm-linux-gnueabihf.tar.gz
# pivx-3.1.1-high-sierra-only.dmg
# pivx-3.1.1-i686-pc-linux-gnu.tar.gz
# pivx-3.1.1-osx64.tar.gz
# pivx-3.1.1-osx-unsigned.dmg
# pivx-3.1.1.tar.gz
# pivx-3.1.1-win32-setup-unsigned.exe
# pivx-3.1.1-win32.zip
# pivx-3.1.1-win64-setup-unsigned.exe
# pivx-3.1.1-win64.zip
# pivx-3.1.1-x86_64-linux-gnu.tar.gz

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
		;;
	esac		
}

pivxdl::urlBuilder(){
	desired_os="$1"
	echo "https://github.com/PIVX-Project/PIVX/releases/download/$(pivxdl::getLatestVersion)/$(pivxdl::urlPrefix)$(pivxdl::urlSuffix $desired_os)"
}


flag="$1"
pivxdl::urlBuilder "$flag"



