#!/bin/bash
IP_USAGE=ip.calico.usage.dat
calicoctl get workloadendpoint -o wide >$IP_USAGE

IP_UNALLOC=ip.unallocate.dat
./calico.all.unallocate.ip.sh >$IP_UNALLOC

IP_RETURN=ip.need.return.dat
grep -f $IP_UNALLOC $IP_USAGE >$IP_RETURN
cat $IP_RETURN |awk '{ print $3 }' |awk --field-separator="." '{ print "kubectl -n "$1" delete pod "$2 }' >pod.rebuild.sh

HOST_TUNNEL=host.tunnel.ip.dat
./calico.ipip.tunnel.ip.sh 2>/dev/null| awk '{print $1}' >$HOST_TUNNEL

TUNNEL_IP_UN_RECORD=tunnel.ip.need.record.dat
grep -f $HOST_TUNNEL $IP_UNALLOC >$TUNNEL_IP_UN_RECORD

TUNNEL_IP_RETURN=tunnel.ip.need.return.dat
grep -f $HOST_TUNNEL $IP_USAGE > $TUNNEL_IP_RETURN
cat $TUNNEL_IP_RETURN |awk '{ print $3 }' |awk --field-separator="." '{ print "kubectl -n "$1" delete pod "$2 }' >>pod.rebuild.sh

echo 'echo "finished"' >>pod.rebuild.sh
#bash ./pod.rebuild.sh
