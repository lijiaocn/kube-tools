#!/bin/bash

MAX_PIDS=1000
CGROUP_PIDS=/sys/fs/cgroup/pids
SYSTEM_SLICE=/sys/fs/cgroup/pids/system.slice/

echo "set @ `date`">/tmp/pids_setting.latest

if [ ! -d $CGROUP_PIDS ];then
	mkdir -p $CGROUP_PIDS
	mount -t cgroup -o pids none $CGROUP_PIDS
fi
for i in `find /sys/fs/cgroup/pids/docker/* -type d`;
do
	echo $MAX_PIDS > $i/pids.max
done
