#!/bin/bash

MAX_PIDS=1000
CGROUP_PIDS=/sys/fs/cgroup/pids
SYSTEM_SLICE=/sys/fs/cgroup/pids/system.slice/

if [ ! -d $CGROUP_PIDS ];then
	mkdir -p $CGROUP_PIDS
	mount -t cgroup -o pids none $CGROUP_PIDS
fi
for i in `ls $SYSTEM_SLICE | grep "docker-"`;
do
	echo $i
	echo $MAX_PIDS > $SYSTEM_SLICE/$i/pids.max
done
