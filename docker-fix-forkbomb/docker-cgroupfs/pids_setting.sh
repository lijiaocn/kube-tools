#!/bin/bash

MAX_PIDS=1000
CGROUP_PIDS=/sys/fs/cgroup/pids
SYSTEM_SLICE=/sys/fs/cgroup/pids/system.slice/

DOCKER=/sys/fs/cgroup/pids/docker/*
KUBEPODS=/sys/fs/cgroup/pids/kubepods

echo "set @ `date`">/tmp/pids_setting.latest

if [ ! -d $CGROUP_PIDS ];then
	mkdir -p $CGROUP_PIDS
	mount -t cgroup -o pids none $CGROUP_PIDS
fi

for i in `find $DOCKER -type d`;
do
	echo $MAX_PIDS > $i/pids.max
done

for i in `find $KUBEPODS -name "pod*" -type d`;
do
	echo $MAX_PIDS > $i/pids.max
done
