#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}
. ${prefix}/etc/fws/config.sh
. ${exec_prefix}/lib/sh/libfws.sh


####
tmpf=/tmp/$(date +%s).$$

#### database path
# database="/var/fws/db/database"

####
if [ "X${QUERY_STRING}" != "X" ]; then
	printf "%s" "${QUERY_STRING}" > $tmpf
elif [ ${CONTENT_LENGTH:-0} -gt 0 ]; then
	cat > $tmpf
else
	printf "fatal: wrong input\n"
	exit 1
fi

####
read input_val < $tmpf
OLDFIS="$IFS"
IFS="&="
set -- $input_val
IFS="$OLDIFS"

####
while [ $# -gt 0 ]
do
	case $1 in
		username) shift; username="$1";   shift;;
		vnc)      shift; vnc="$1";        shift;;
		*)        echo "wrong input: $1"; shift;;
	esac
done

#### databaseを参照して、usernameとvncで一致したVMを起動する
vm_bokan_ip=`awk "/$vnc $username/{print \\$6}" $database`
vm_cpu=`awk "/$vnc $username/{print \\$3}" $database`
vm_ram=`awk "/$vnc $username/{print \\$4}" $database`

## if value isNull -> exit1
if [ -z "$vm_bokan_ip" ]; then
	echo "params -> username:$username, ip=$vm_bokan_ip, vm_cpu:$vm_cpu,\
        vm_ram:$vm_ram" > /home/vmm-admin/params.log
	exit 1
fi

start_cmd="${libexec_dir}/vm_start.sh $username$vnc ${vnc} ${vm_cpu} ${vm_ram}"


`timeout -sKILL 5 ssh fws@$bokan_ip ${start_cmd}`

#### JSON
printf "{"
printf "\"status\":\"ok\""
printf "}"

exit 0
