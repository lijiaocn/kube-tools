---
layout: default
title: README
author: lijiaocn
createdate: 2017/12/08 19:43:04
changedate: 2017/12/11 12:18:24

---

## 说明

这套脚本是用来检测kubernetes集群中的Pod的IP的。

## 使用

将`ping_monitor.sh`加入到定时任务中：

	*/5    *  *  *  * cd /root/lijiao/ip_monitor; /bin/bash ping_monitor.sh

`ping_monitor.sh`每五分钟执行一次，将无法ping的ip记录在`output`目录中：

	▾ output/
		192.168.10.192

到`./unaccessible`目录中执行脚本`prepare.sh`查看不可访问的IP的状态：

	$ ./prepare.sh
	-------- ip unaccesible -----------
	-------- calico -------------------
	-------- kubernetes ---------------
	-------- calico ip conflict -------
	-------- kubenetes ip confict -----
	-------- rebuild pods -------------

如果存在不可访问的IP，并且对应的pod可以删除后自动重建，执行:

	/bin/bash  pod.rebuild.sh
