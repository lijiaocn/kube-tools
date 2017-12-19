#!/bin/bash

result="output"
if [ ! -d $result ];then
	mkdir -p $result
fi

#for i in "/calico/ipam/v2/assignment/ipv4/block/192.168.106.64-26"
#for i in "/calico/ipam/v2/assignment/ipv4/block/192.168.70.0-26"
#for i in "/calico/ipam/v2/assignment/ipv4/block/192.168.77.128-26"
for i in `etcdctl ls /calico/ipam/v2/assignment/ipv4/block`
do	
	echo "=================================================================================="
	echo $i
	json=`etcdctl get $i` 

	host=`echo $json | jq -r '.affinity' |sed -e "s/host://"`
	if [[ "$host" == "null" ]];then
		echo "skip $host $i affinity not found"
		continue
	fi
	block=`echo $json | jq -r '.cidr'`

	ip_start=`echo $block | sed "s/\([0-9]*\.\)\{3\}//" | sed "s/\/26//"`

	echo "host=$host"
	echo "block=$block"
	echo "ip_start=$ip_start"

	etcdctl get /calico/v1/host/$host/config/IpInIpTunnelAddr  2>/dev/null
	ret=$?
	if [[ "$ret" != 0 ]];then
		echo "skip $host $i IpInIpTunnelAddr not set"
		continue
	fi

	ipip=`etcdctl get /calico/v1/host/$host/config/IpInIpTunnelAddr 2>/dev/null | sed "s/\([0-9]*\.\)\{3\}//"`
	let ipip_pos=$ipip-$ip_start
	echo $ipip_pos
	if [ $ipip_pos -lt 0 ];then
		echo "skip $host $i tunl0's ip is strange, not in block, too small"
		continue
	fi
	if [ $ipip_pos -gt 63 ];then
		echo "skip $host $i tunl0's ip is strange, not in block, too large"
		continue
	fi

	allocations='{"allocations":[]}'
	allocations=`echo $allocations | jq -r ".allocations[63]=null"`
	attributes="[ "

	index=0
	attributes="$attributes { \"handle_id\": null, \"secondary\": null },"
	allocations=`echo $allocations | jq -r ".allocations[$ipip_pos]=$index"`

	index=1
	for wl in `./get.real.workloadendpoint.index.sh $host $ip_start`;do
		name=`echo $wl | sed "s/@.*//"`
		ip_pos=`echo $wl | sed "s/.*@//"`
		attributes="$attributes { \"handle_id\": \"$name\", \"secondary\": null },"
		allocations=`echo $allocations | jq -r ".allocations[$ip_pos]=$index"`
		let index+=1
	done
	attributes=`echo $attributes | sed "s/,$//"`
	attributes="$attributes ]"
	allocations=`echo $allocations | jq -r ".allocations"`

	str=`./get.real.unallocate.ip $host $ip_start |awk '{ print $1","}'`
	unallocate_ips="[ "
	unallocate_ips="$unallocate_ips`echo $str| sed "s/,$//"`"
	unallocate_ips="$unallocate_ips ]"
	
	echo $i
	echo $json |jq ".allocations=$allocations | .unallocated=$unallocate_ips |.attributes=$attributes" >$result/$host.json
	etcdctl get $i |jq ".">$result/$host.bak.json

# uncomment this line to update ipam data in etcd 
#	etcdctl set $i "`cat $result/$host.json`" >/dev/null
done
