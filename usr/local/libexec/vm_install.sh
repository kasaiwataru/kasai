#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}
. ${prefix}/etc/fws/config.sh
. ${exec_prefix}/lib/sh/libfws.sh

usage () {
    local name=$(basename $0)
    
    cat <<__HELP__

[Usage]
   $name [-d] [-i] [-h] args...

   $name -i
or
   $name VM_IMAGE_NAME DISK_SIZE

__HELP__
}

# getopts: POSIX option parser
while getopts dih _argv
do
    case $_argv in
	d) is_debug=1       ;;
	i) is_interactive=1 ;;
	h)            usage ;;
	\?)   usage; exit 1 ;;
    esac
done
shift $((OPTIND - 1))


#
# MAIN
#

# interactive mode
if [ "X$is_interactive" = "X1" ];then
    vm_input_params
    vm_input_cdrom_iso
else
    disk_image=$1
    vnc_number=$2
    num_core=$3
    mem_size=$4
    cdrom_image=$5
fi

if [ "X$disk_image" != "X" ] && [ "X$vnc_number" != "X" ] && \
   [ "X$num_core" != "X" ]   && [ "X$mem_size" != "X" ]   && \
   [ "X$cdrom_image" != "X" ]; then
    net_create_vtap $vnc_number
    qemu_run $disk_image $vnc_number $num_core $mem_size $cdrom_image
else
    usage
fi

exit 0
