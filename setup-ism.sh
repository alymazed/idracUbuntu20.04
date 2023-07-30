#!/bin/bash

echo " [WARNING] Use this script at your own risk. This is not provided or endorsed by Dell Inc."
echo " Press ENTER/RETURN to continue or Ctrl-C to cancel."
read -s

echo " > Setting up temp directories" 
cd /tmp || exit 1
rm -rf idrac-install
mkdir idrac-install
cd idrac-install || exit 1

echo " > Downloading iSM"
wget -q https://dl.dell.com/FOLDER08068478M/1/OM-iSM-Dell-Web-LX-4200-2581_A00.tar.gz
[[ ! -f OM-iSM-Dell-Web-LX-4200-2581_A00.tar.gz ]] && echo " [ERROR] Download unsuccessful." && exit 1
tar xzf OM-iSM-Dell-Web-LX-4200-2581_A00.tar.gz
echo " > Updaing OS version"
[[ ! -f setup.sh ]] && echo " [ERROR] Setup file not found." && exit 1 
sed -i -E 's/"\$VER" == "20"/"\$VER" == "22"/' setup.sh
[[ -z "$(cat setup.sh | grep '== "22"')" ]] && echo " [ERROR] Setup file not successfully updated." && exit 1


if [[ -z "$(sudo find /usr -name libcrypto.so.1.1)" ]];
then
    wget -q http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
    sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb 2> /dev/null
    [[ -z "$(sudo find /usr -name libcrypto.so.1.1)" ]] && echo " [ERROR] libssl not installed." && exit 1
fi
echo " > Starting iSM installer ..."
sudo ./setup.sh