#!/bin/bash
CALICO_IPS=calico.ip.dat
POD_IPS=k8s.ip.dat
CALICO_ALL=calico.all.dat
K8S_ALL=k8s.all.dat
flush(){
	calicoctl get workloadendpoints -o wide  >$CALICO_ALL
	cat $CALICO_ALL  |awk '{if(NR>1) print $5}' |sed 's@/32@@' >${CALICO_IPS}
	kubectl get pod --all-namespaces -o wide >$K8S_ALL
	cat $K8S_ALL |grep "Running"|awk '{print $7}' |grep -v none|grep -v "=" >${POD_IPS}
}
echo "Check @`date`" >>./process.log
flush

if [ ! -d ./output ];then
	mkdir ./output
fi

if [ ! -d ./back_output ];then
	mkdir ./back_output
fi

mv -f ./output/*  ./back_output/

while read ip
do
	if [[ "$ip" != "" ]];then
	./ping.sh $ip &
	fi
done < $CALICO_IPS

while read ip
do
	if [[ "$ip" != "" ]];then
	./ping.sh $ip &
	fi
done < $POD_IPS
