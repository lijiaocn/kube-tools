#!/bin/bash

DESTDIR=/export/docker
TEMPFILE=/tmp/crondtab_pid_setting

if [ ! -d $DESTDIR ];then
	mkdir -p $DESTDIR
fi

cp -f ./pids_setting.sh $DESTDIR

echo "*/1  *  *  *  *  ${DESTDIR}/pids_setting.sh" >$TEMPFILE
crontab -u root $TEMPFILE
