#!/bin/bash

apt-get update -yqq
apt-get upgrade -yqq
apt-get install -yqq vim

cp /home/debian/.bashrc ~/.bashrc
sed -i 's#;32m#;33m#g' ~/.bashrc
. ~/.bashrc

VIMVERS=$(ls /usr/share/vim | grep -i vim)
if [ ! -f /usr/share/vim/$VIMVERS/colors/mycolors.vim ] ; then
    wget -qO /usr/share/vim/$VIMVERS/colors/mycolors.vim https://raw.githubusercontent.com/Vaadasch/myutils/main/vimconfig/mycolors.vim
    wget -qO ~/.vimrc https://raw.githubusercontent.com/Vaadasch/myutils/main/vimconfig/.vimrc
fi

if [ ! -f /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg ]; then
        read -p "Voulez-vous ajouter une deuxième adresse IP ?" addIP
        if [[ "$addIP" != "" && $addIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] ; then
                echo "network: {config: disable}" >> /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
                lineADDR=$(( $(grep -n addresses /etc/netplan/50-cloud-init.yaml | head -n 1 | awk -F ':' '{print $1}') + 1 ))
                sed -i "${lineADDR}a\ \ \ \ \ \ \ \ \ \ \ \ - ${addIP}/34" /etc/netplan/50-cloud-init.yaml
        fi
fi




localDisk=$(mount | grep " on / " | awk '{print $1}' | awk -F '/' '{print $NF}' | sed 's#\([Z-a]*\)[0-9]#\1#g' )
nbVols=$(lsblk -l | grep ' disk ' | grep -v $localDisk | wc -l )
nbParts=$(lsblk -l | grep ' part ' | grep -v $localDisk | wc -l)
if [ $nbVols != $nbParts ] ; then
        echo "Volumes a configurer : "
        echo "Déconnecter les volumes pour les identifier"
        echo "echo ';' | sfdisk /dev/sdX     # Pour créer une table de partitions"
        echo "mkfs.ext4 -L <VOL-NAME> /dev/sdX1     # Pour formater une partition"
        echo ""
        echo "ajouter UUID des disks dans /etc/fstab"
fi


mountedInfraVerif=$(mount | grep -i ' on /volumes/vol-infra' | wc -l )
if [ $mountedVerif != 1 ] ; then
        echo "Missing mounted volume INFRA. Exiting"
        exit 1
fi

if [ ! -d /volumes/vol-infra/docker/portainer ] ; then
    mkdir /volumes/vol-infra/docker/portainer
    cd /volumes/vol-infra/docker/portainer
    wget -qO start.sh https://github.com/Vaadasch/myutils/raw/main/docker/start_portainer.sh
    chmod +x start.sh
    ./start.sh
fi
                                        
