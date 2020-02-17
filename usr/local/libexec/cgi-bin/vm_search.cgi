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
OLDIFS="$IFS"
IFS="&="
set -- $input_val
IFS="$OLDIFS"

####
while [ $# -gt 0 ]
do
	case $1 in
		username) shift;   username="$1"; shift;;
		*)        echo "wrong input: $1"; shift;;
	esac
done

# databaseから学籍でVMを検索
vm_exist=`awk '/'${username}'/' ${database} | wc -l`

# 学籍で紐付いたVMの一覧をJSONで返却
printf "Content-Type: text/json\n\n"
printf "{"
for num in `seq 1 $vm_exist`
do
	vm_list_item=`awk '/'${username}'/' ${database} | sed -n ${num}p`
	case $num in
		$vm_exist) printf "\"vm${num}\":\"%s\"" "${vm_list_item}";;
		*)         printf "\"vm${num}\":\"%s\"", "${vm_list_item}";;
	esac
done
printf "}"

exit 0
