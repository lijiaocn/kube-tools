---
layout: default
title: Calico的IPAM数据重建
author: lijiaocn
createdate: 2017/12/12 09:12:00
changedate: 2017/12/12 10:00:16

---

* auto-gen TOC:
{:toc}

## 说明

calico中存放的IPAM数据与实际情况对应不上，多出了很多的handler，需要进行重建。

在以下版本中使用过：

	|   calico version    |  calico cni version |
	|---------------------|---------------------|
	|     2.0.0           |  v1.11.1            |
	|     2.0.0           |  v1.5.0             |

## IPAM数据格式

	$ etcdctl get  /calico/ipam/v2/assignment/ipv4/block/192.168.106.64-26
	{
	  "cidr": "192.168.106.64/26",
	  "affinity": "host:dev-slave-108",
	  "strictAffinity": false,
	  "allocations": [
	    null,
	    null,
	    null,
	    3,
	   ...
	 ],
	  "unallocated": [
	    0,
	    1,
	    2,
	    4,
	    5,
	    6,
	    7,
	    ...
	 ],
	  "attributes": [
	    {
	      "handle_id": "kube-system.prometheus-3355405412-iyww3",
	      "secondary": null
	    },
	    {
	      "handle_id": "kube-system.kubernetes-dashboard-2069275773-iun7h",
	      "secondary": null
	    },
	  ]
	}

## 使用

总共有四个脚本：

	get.real.allocate.ip                获取指定host上实际已分配IP
	get.real.unallocate.ip              获取指定host上未分配的IP
	get.real.workloadendpoint.index.sh  获取指定host上实际存在的workloadendpoint和对应的IP
	reset_ip_block.sh                   调用上面的脚本完成IPAM数据的重建

重建数据直接执行:

	./reset_ip_block.sh | grep skip

这个脚本会在当前目录下新建一个output目录存放计算出的结果。

如果要直接更新etcd中的记录，将reset_ip_block.sh中倒数第二行前面的注释去掉：

	# uncomment this line to update ipam data in etcd 
	#	etcdctl set  $i "`cat $result/$host.json`" >/dev/null

异常的node，会跳过，例如：

	skip /calico/ipam/v2/assignment/ipv4/block/172.32.27.64-26 affinity not found
	skip /calico/ipam/v2/assignment/ipv4/block/172.32.41.64-26 affinity not found
	skip /calico/ipam/v2/assignment/ipv4/block/192.168.250.192-26 tunl0's ip is strange, not in block, too small
	skip /calico/ipam/v2/assignment/ipv4/block/172.32.164.0-26 affinity not found
	skip /calico/ipam/v2/assignment/ipv4/block/192.168.136.0-26 affinity not found
	skip /calico/ipam/v2/assignment/ipv4/block/192.168.60.128-26 tunl0's ip is strange, not in block, too large
	Error:  100: Key not found (/calico/v1/host/paas-dev-140) [72201008]
	skip /calico/ipam/v2/assignment/ipv4/block/192.168.243.128-26 IpInIpTunnelAddr not set
	skip /calico/ipam/v2/assignment/ipv4/block/172.32.181.0-26 affinity not found

