#!/bin/bash
node=$1
start=$2

#test
#node="dev-slave-110"
#start=0

for wl in `calicoctl get workloadendpoint -o wide |grep $node |awk '{print $3"@"$5}' |sed "s/\\/32//"`
do
	name=`echo $wl |sed "s/@.*//"`
	ip_offset=`echo $wl |sed "s/.*@//" |sed  "s/\([0-9]*\.\)\{3\}//"`
	echo "$name@$ip_offset"
done


