#!/bin/bash

for host in `etcdctl ls /calico/v1/host`
do
	tunnel_ip=`etcdctl get "$host/config/IpInIpTunnelAddr"`
	echo -e "$tunnel_ip\t$host"
done
