#!/bin/bash
declare -A map
for i in `find /proc/*/mounts -exec grep $1 {} + 2>/dev/null | awk '{print $1"#"$2}'`
do
	pid=`echo $i | awk -F "[/]" '{print $3}'`
	point=`echo $i | awk -F "[#]" '{print $2}'`
	mnt=`ls -l /proc/$pid/ns/mnt |awk '{print $11}'`
	map["$mnt"]="exist"
	cmd=`cat /proc/$pid/cmdline`
	echo -e "$pid\t$mnt\t$cmd\t$point"
done

for i in `ps aux|grep docker-containerd-shim |grep -v "grep" |awk '{print $2}'`
do
	mnt=`ls -l /proc/$i/ns/mnt  2>/dev/null | awk '{print $11}'`
	if [[ "${map[$mnt]}" == "exist" ]];then
		echo $mnt
	fi
done
