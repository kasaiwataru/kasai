#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}

qemu_create_disk_image () {
    local disk_image=$1
    local  disk_size=$2
    local  disk_path=$disk_dir/$disk_image
    
    test -d $disk_dir  || mkdir $disk_dir
    test -d $cdrom_dir || mkdir $cdrom_dir
 
    qemu-img create -f qcow2 $disk_path $disk_size >/dev/null 2>&1

    # return status 
    test -s $disk_path && echo $disk_image || echo ""
}

qemu_run () {
    local  disk_image=$1
    local  vnc_number=$2
    local    num_core=$3
    local    mem_size=$4
    local cdrom_image=$5
    local   disk_path=$disk_dir/$disk_image
    local  cdrom_path=$cdrom_dir/$cdrom_image
    local  _use_cdrom
    local    mac_addr

    mac_addr=$($libexec_dir/vm_macaddr_hasher.py ${disk_image}${vnc_number})

    # data cleansing
     disk_path=$(  echo $disk_path  | sed 's/.qcow2$//' )
    cdrom_path=$( echo $cdrom_path | sed 's/.iso$//'   )
	       
    local qemu_options="
	-enable-kvm                                    \
	-machine type=pc,accel=kvm                     \
	-vga std                                       \
	-nographic                                     \
	-hda       $disk_path.qcow2                    \
	-vnc       :$vnc_number                        \
	-cpu       host                                \
	-smp       $num_core                           \
	-m         $mem_size                           \
	-k ja                                          \
	-net nic,macaddr=$mac_addr                     \
	-net tap,ifname=vtap${vnc_number}              "

    if [ "X$cdrom_image" != "X" ];then
	vm_db_insert $vnc_number $disk_image $num_core $mem_size $mac_addr
	qemu-system-x86_64 $qemu_options -boot d -cdrom ${cdrom_path}.iso &
    else
	qemu-system-x86_64 $qemu_options -boot c                           &
    fi

}


vm_input_params () {
    echo "ディスクイメージを入力してください(Not Input .qcow2)"
    ls -l $disk_dir
    
    read disk_image
    
    echo "VNC番号を選択してください"
    read vnc_number
    
    echo "仮想CPUのコア数を設定してください"
    read num_core
    
    echo "メモリ容量を入力してください(MB単位)"
    read mem_size
}


vm_input_cdrom_iso () {
    echo "インストールイメージを選択してください(Not Input .iso)"
    echo "=============================="
    ls -l $cdrom_dir
    echo "=============================="
    read cdrom_image
}

net_create_vtap () {
    local vnc_number=$1
    local _vtap
    local found

    # check the vtap is already exists or not.
    _vtap=$(printf "vtap%d" $vnc_number)
    found=$(/bin/ip tuntap | awk '{print $1}' | grep $_vtap:)

    # if not found, create it
    if [ "X$found" = "X" ];then
	sudo tunctl -u $bokan_user -t $_vtap
    fi
}


#
# USER DATABASE MANUPULATION
#

# $database format must be
#  $vnc_number $id $num_core $mem_size $disk_size $ip_addr $mac_addr
# e.g.
#      3  b2902929     1    2000    2        192.168.10.10 aa:bb:cc:dd:ee:ff
#
vm_db_insert () {
    local  vnc_number=$1
    local          id=$2
    local    num_core=$3
    local    mem_size=$4
    local    mac_addr=$5
    local     ip_addr=$6
    
    # save the installation parameters
    printf "%s\t%s\t%s\t%s" $vnc_number $id $num_core $mem_size >> $database
    printf "\t%s\t%s\n"     $mac_addr $ip_addr                  >> $database
}
