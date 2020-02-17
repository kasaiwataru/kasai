#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}
. ${prefix}/etc/fws/config.sh
. ${exec_prefix}/lib/sh/libfws.sh

usage () {
    local name=$(basename $0)
    
    cat <<__HELP__

[Usage]

    $name newimage     create a new qcow2 file
    $name newqcow2     same above
    
    $name newvm        install mode to the qcow2 file.
    $name install      save above

    $name start        start the specified qemu image (.qcow2)

    $name rmvm,stop    NOT IMPLEMENTED YET

[Example]

    % $name newimage
    % $name install
    % $name start
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

# interactive mode
if [ "X$is_interactive" = "X1" ];then
   case $1 in
       newimage|newqcow2)            $libexec_dir/vm_create.sh -i ;;
       newvm|install)               $libexec_dir/vm_install.sh -i ;;
       rmvm)                      echo "not yet supported ;-)"    ;;
       start)                         $libexec_dir/vm_start.sh -i ;;
       stop)                      echo "not yet supported ;-)"    ;;
       help|*)                                           usage    ;;
   esac
else
   case $1 in
       newimage|newqcow2)            $libexec_dir/vm_create.sh    ;;
       newvm|install)               $libexec_dir/vm_install.sh    ;;
       rmvm)                      echo "not yet supported ;-)"    ;;
       start)                         $libexec_dir/vm_start.sh    ;;
       stop)                      echo "not yet supported ;-)"    ;;
       help|*)                                           usage    ;;
   esac
fi

exit 0
