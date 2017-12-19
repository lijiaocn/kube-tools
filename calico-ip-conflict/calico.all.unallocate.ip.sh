#!/bin/bash
#for i in `echo /calico/ipam/v2/assignment/ipv4/block/192.168.45.128-26`
for i in `etcdctl ls /calico/ipam/v2/assignment/ipv4/block`
do
	block=`etcdctl get $i |jq -r '.cidr'`
	ip_prefix=`echo $block | sed  "s/\(\([0-9]*\.\)\{3\}\).*/\1/"`
	ip_mask=`echo $block |sed  "s/\([0-9]*\.\)\{3\}//" |sed "s/\/26//"`
	for j in `etcdctl get $i |jq '.unallocated'|jq '.[]'`
	do
		let sub=$ip_mask+$j
		echo $ip_prefix$sub/32
	done
done

