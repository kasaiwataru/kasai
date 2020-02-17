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
   echo -n "ディスク名(ホスト名)を入力してください: "
   read disk_name

   echo -n "ディスク容量を入力してください(GB単位): "
   read disk_size
else
   disk_name=$1
   disk_size=$2
fi

status=""
if [ "X$disk_name" != "X" ] && [ "X$disk_size" != "X" ];then
    status=$( qemu_create_disk_image ${disk_name}.qcow2 ${disk_size}G)
else
    usage
fi

if [ "X$status" != "X" ]; then
    echo "OK: ディスクイメージ $status が作成されました。"
    exit 0
else
    echo "ERROR: ディスクイメージの作成に失敗しました。"
    exit 1
fi
