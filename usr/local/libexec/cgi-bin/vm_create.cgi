#!/bin/sh

prefix=/usr/local
exec_prefix=${prefix}
. ${prefix}/etc/fws/config.sh
. ${exec_prefix}/lib/sh/libfws.sh

# local temporary variables
tmpf=/tmp/$(date +%s).$$
trap "rm $tmpf" 0 1 3 15

#
# INPUT via HTTP POST method
#
if [ "X${QUERY_STRING}" != "X" ]; then
  printf "%s" "${QUERY_STRING}" > $tmpf
elif [ ${CONTENT_LENGTH:-0} -gt 0 ]; then
  cat > $tmpf
else
  printf "fatal: wrong input\n"
  exit 1
fi

# parse input parameters
read input_val < $tmpf
OLDIFS="$IFS"
IFS="&="
set -- $input_val
IFS="$OLDIFS"

while [ $# -gt 0 ]
do
  case $1 in
      username)  shift;  username="$1"; shift ;;
      cpu)       shift;       cpu="$1"; shift ;;
      memory)    shift;    memory="$1"; shift ;;
      storage)   shift;   storage="$1"; shift ;;
      *)         echo "wrong input:$1"; shift ;;
  esac
done


#
# MAIN
#
sh ${libexec_dir}/order_install.sh $username $storage $cpu $memory
vm_create_status=$?

####
latest_vmid=$(awk '/'$username'/{print $1}' $database | sed -n '$p')
if [ -z $latest_vmid ]; then
  log="[ERROR] Can't find Data params:vmid, latest_vmid=$latest_vmid"
fi

latest_vmip=$(awk '/'$username'/{print $6}' $database | sed -n '$p')
if [ -z $latest_vmip ]; then
  log="[ERROR] Can't find Data params:ip"
fi


#
# OUTPUT: return status via HTTP
#
printf "Content-Type: text/json\n\n"
printf "{"
printf "\"gvnc\":\"gvncviewer %s:%s\"", "${latest_vmip}" "${latest_vmid}"
printf "\"logs\":\"%s\"" "${log}"
printf "}"

exit 0
