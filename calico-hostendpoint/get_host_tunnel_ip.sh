#!/bin/bash
name=$1
#name="test-master-113"
host="/calico/v1/host/$name"
tunnel_ip=`etcdctl get "$host/config/IpInIpTunnelAddr"`
echo  $tunnel_ip
