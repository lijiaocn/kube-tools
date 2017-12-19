#!/bin/bash
ping -c 5 -W 10 $1 
ret=$?
if [ $ret != 0 ];then
	echo "$1  @`date`" >>./output/$1
fi
