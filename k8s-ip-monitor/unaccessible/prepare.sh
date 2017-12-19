#!/bin/bash
CALICO_IPS=calico.ip.dat
POD_IPS=k8s.ip.dat
CALICO_ALL=calico.all.dat
K8S_ALL=k8s.all.dat

/bin/cp -f ../$CALICO_ALL ./
/bin/cp -f  ../$K8S_ALL ./

echo "-------- ip unaccesible -----------"
IP_UNACCES=ip.unaccesible.dat
ls -l ../output/ |awk '{if (NR>1) print $9}'  > $IP_UNACCES
cat $IP_UNACCES

echo "-------- calico -------------------"
CALICO_UNACCES=calico.unaccesible.dat
grep -f $IP_UNACCES $CALICO_ALL >$CALICO_UNACCES
cat $CALICO_UNACCES
cat $CALICO_UNACCES |awk '{print "calicoctl delete workloadendpoint "$4" --node="$1" --workload="$3" --orchestrator="$2}' >calico.delete.sh

echo "-------- kubernetes ---------------"
K8S_UNACCES=k8s.unaccesible.dat
grep -f $IP_UNACCES $K8S_ALL  >$K8S_UNACCES
cat $K8S_UNACCES

echo "-------- calico ip conflict -------"
CALICO_CONFLICT=calico.conflict.ip.dat
cat $CALICO_ALL |awk '{print $5}'|sort |uniq -c |sort -n |grep -v " 1" >$CALICO_CONFLICT
cat $CALICO_CONFLICT

echo "-------- kubenetes ip confict -----"
k8S_CONFLICT=k8s.conflict.ip.dat
cat $K8S_ALL |awk '{ print $7 }'|grep -v none|grep -v "="|grep -v "10.39" |sort |uniq -c |sort -n |grep -v "1 " >$K8S_CONFLICT
cat $K8S_CONFLICT

echo "-------- rebuild pods -------------"
cat $K8S_UNACCES |awk '{print "kubectl -n "$1" delete pod "$2}' >pod.rebuild.sh
