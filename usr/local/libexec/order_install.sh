#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}
. ${prefix}/etc/fws/config.sh
. ${exec_prefix}/lib/sh/libfws.sh

if [ ! -e $database ]; then
	touch $database
fi

# PARAMS
#
# username      : student id
# disk_name     : $username + vmid(vnc_number)
# disk_size     : storage (specified by GB)
# num_core      : NUMBER OF CPU CORE (cores)
# mem_size      : Memory (MB)
# vnc_number    : vmid (unique), speculated by lookup-ing database
#
# [etc/fws/config.sh]
# bokan_user    : host machine's host name
# bokan_ip      : host machine's ip address
#

username=$1
disk_size=$2
num_core=$3
mem_size=$4

# if youre's vm deleted, new VM's VNC number lookup in delete_list
last_num=`awk '{print $1}' ${database} | sort -n | tail -1`
if [ -z $last_num ]; then
	last_num=0
fi
vnc_number=`echo $(($last_num+1))`

disk_name=${username}${vnc_number}

# create a new qemu VM image on a bokan
command="${libexec_dir}/vm_create.sh  ${disk_name}"
command="$command ${disk_size}"
timeout -sKILL 5 ssh ${bokan_user}@${bokan_ip} $command

# run the created qemu with the corresponding image on the bokan
command="${libexec_dir}/vm_install.sh ${disk_name}"
command="$command ${vnc_number} ${num_core} ${mem_size} ${os_installer_iso}"
timeout -sKILL 5 ssh ${bokan_user}@${bokan_ip} $command

exit 0
