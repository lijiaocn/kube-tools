#!/bin/bash
IP_USAGE=ip.calico.usage.dat
calicoctl get workloadendpoint -o wide >$IP_USAGE
IP_UNALLOC=ip.unallocate.dat
./calico.all.unallocate.ip.sh >$IP_UNALLOC
IP_RETURN=ip.need.return.dat
grep -f $IP_UNALLOC $IP_USAGE >$IP_RETURN
cat $IP_RETURN |awk '{ print $3 }' |awk --field-separator="." '{ print "kubectl -n "$1" delete pod "$2 }' >pod.rebuild.sh
HOST_TUNNEL=host.tunnel.ip.dat
./calico.ipip.tunnel.ip.sh >$HOST_TUNNEL
grep -f $IP_UNALLOC $HOST_TUNNEL >tunnel.ip.need.return.dat
