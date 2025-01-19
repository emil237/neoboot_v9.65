#!/bin/bash
# ###############################################
echo " SCRIPT : DOWNLOAD AND INSTALL NEOBOOT "
# ###########################################
NEOBOOT='v9.65'
###########################################
# Configure where we can find things here #
MY_EM="*****************************************************************************************************"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot'
##########################################
REQUIRED='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot/files'
##########################################
TOOLS='/usr/lib/enigma2/python/Tools'
PREDION='/usr/lib/periodon'
##########################################
##########################################
PYTHON_VERSION=$(python -c "import platform; print(platform.python_version())")

###########################################

# remove old version
if [ -d "$PLUGINPATH" ]; then
   rm -rf "$PLUGINPATH"
fi

# Python Version Check #
PYTHON=$(python --version 2>&1)
if [[ $PYTHON == "Python 3."* ]]; then
   echo "You have Python3 image"
   PYTHON='PY3'
else
   echo "You have Python2 image"
   PYTHON='PY2'
fi
#########################

VERSION=$NEOBOOT

#######################################
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install --force-overwrite --force-reinstall'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#########################
case $(uname -m) in
armv7l*) platform="armv7" ;;
mips*) platform="mipsel" ;;
aarch64*) platform="ARCH64" ;;
sh4*) platform="sh4" ;;
esac

#########################
install() {
    if ! grep -qs "Package: $1" "$STATUS"; then
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Need to install $1   <<<<"
        echo
        $OPKGINSTAL "$1"
        sleep 1
        clear
    fi
}

#########################
for i in kernel-module-nandsim mtd-utils-jffs2 lzo python-setuptools util-linux-sfdisk packagegroup-base-nfs ofgwrite bzip2 mtd-utils mtd-utils-ubifs; do
    install "$i"
done

#########################
clear
sleep 5
opkg update
echo "   UPLOADED BY  >>>>   EMIL_NABIL " 
sleep 4
echo " SUPPORTED BY  >>>>  linuxsat  " 
sleep 4
echo " Moded By Elsafty"
sleep 4
echo "***********************************************************************
#########################
clear                                                                               
echo "**********************************************************************************"
wget -O /var/volatile/tmp/enigma2-plugin-extensions-neoboot-v9.65-by-linuxsat_mod-elsafty.tar.gz "https://github.com/emil237/download-plugins/raw/main/enigma2-plugin-extensions-neoboot-v9.65-by-linuxsat_mod-elsafty.tar.gz"
wait
tar -xzf /var/volatile/tmp/enigma2-plugin-extensions-neoboot-v9.65-by-linuxsat_mod-elsafty.tar.gz -C /
rm -f /var/volatile/tmp/enigma2-plugin-extensions-neoboot-v9.65-by-linuxsat_mod-elsafty.tar.gz

#########################
clear
cd "$PLUGINPATH"
chmod 755 ./bin/*
chmod 755 ./ex_init.py
chmod 755 ./files/*.sh
chmod -R +x ./ubi_reader_arm/*
chmod -R +x ./ubi_reader_mips/*

#########################
echo ""
echo "***********************************************************************"
echo $MY_EM                                                     
echo "**                       NeoBoot  : $VERSION                          *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ". >>>>         RESTARTING     <<<<"
echo ""
if [ "$OSTYPE" = 'DreamOS' ]; then
    systemctl restart enigma2
else
    init 6
fi
exit 0






