---
layout: default
title: README
author: lijiaocn
createdate: 2017/12/11 11:34:19
changedate: 2017/12/11 11:43:48

---

## 说明

这套脚本用来查找在calico中记录为没有分配、却被workloadendpoint使用的IP。

这些IP是可能导致多个POD使用了同一个IP。

## 使用

运行的机器上需要能够访问calico使用的etcd，并安装了命令`jq`。

	./run.sh

运行后会得到下面的dat文件:

	ip.calico.usage.dat         //calico中的workloadendpoint使用的IP
	ip.unallocate.dat           //calico中记录为未分配的IP
	ip.need.return.dat          //为分配却被workloadendpoint使用的IP
	node.local.conflict.dat     //每个calico-node上使用了却被记录为未使用的IP
