#!/bin/sh

database="/var/fws/db/database"
#database=/var/fukamachi-lab-web-service/database
if [ ! -e $database ]; then
	touch $database
fi

# global variables
#
# query_num   : コマンドライン引数(1=insert, 2=update, 3=delete)
# vmid        : VMID、クエリのプライマリキーにするもの
# student_num : 学籍、VM検索の絞りこみとVMの総数を取るのに使う
# cpu         : 
# memory      :
# storage     :
# ip_address  :
# mac_address :
# data_count  : 検索でヒットした行の合計
# dataset     : databaseに入れる値
query_num=$1
vmid=$2
student_num=$3
cpu=$4
memory=$5
storage=$6
ip_address=$7
mac_address=$8

# create dataset
#
create_dataset(){
  dataset="$vmid $student_num $cpu $memory $storage $ip_address $mac_address"
  echo $dataset
}

# select
# grepでdatabaseファイルに学籍+vmidで検索をかける
#
select_data(){
  status=$(awk '{print $1}' $database | grep -e $vmid | sort -n | sed -n 1p)
  if [ -z "$status" ]; then
    echo $status 
  else
     printf "[Error] Query 'SELECT' failed status:$status \n"
    echo $status
  fi
}

# insert
# 
insert_data(){
  data=$(select_data)
  #echo "$data"
  if [ -z "$data" ]; then
    ret_dataset=$(create_dataset)
    echo $ret_dataset >> $database
  else
    printf "[Error] This data is already exists : ${vmid} + ${student_num}\n"
    exit 1
  fi
}

# update?
#
update_data(){}

# delete?
#
delete_data(){}

#
# Main
#
if [ "$query_num" -eq  "1" ]; then
  insert_data
elif [ $query_num -eq "2" ]; then
  update_data
elif [ $query_num -eq "3" ]; then
  delete_data
else
  printf "Bad request QUERY_PARAMS:$query_num\n"
  exit 1
fi

exit 0
