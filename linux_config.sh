#!/usr/bin/env bash

#Use:
    #cd dir
    #chmod +x linux_config.sh
    #sudo ./linux_config.sh


set -e
#java install
cp -r /media/$USER/DEPLOY/linux_package/jre-8u333-linux-x64.tar.gz ~cp -r 
#set -- /media/*/TRANSFER/linux_package
#cp -r ~/Desktop/linux_package/jre-8u333-linux-x64.tar.gz ~

tar zxvf ~/jre-8u333-linux-x64.tar.gz

#nvidia drivers install -----Works
echo 'Y' | apt-get install nvidia-driver-510 nvidia-dkms-510

#cuda install -----Works
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
#eclipse install
echo 'Y' | apt-get install default-jre
snap install --classic eclipse


#ssh install
echo 'Y' | apt-get install ssh

#allow root gui, needs tested
"AllowRoot=true" >> etc/gdm3/custom.conf

sed 's/#auth     required        pam_succeed_if.so user != root quiet_success/auth     required        pam_succeed_if.so user != root quiet_success/' /etc/pam.d/gdm-password

#cron job for monthly check ups
(crontab -u $USER -l ; echo "* * 1 * *  do-release-upgrade") | crontab -u $USER -

#ensures all apps are upgradesapt install update-manager-core
do-release-upgrade

apt update && apt upgrade
reboot


