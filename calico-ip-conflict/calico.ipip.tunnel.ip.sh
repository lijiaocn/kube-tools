#!/bin/bash

for host in `etcdctl ls /calico/v1/host`
do
	tunnel_ip=`etcdctl get "$host/config/IpInIpTunnelAddr"|grep -v Error`
	if [[ "$tunnel_ip" != "" ]];then
		echo -e "$tunnel_ip/32\t$host"
	fi
done
