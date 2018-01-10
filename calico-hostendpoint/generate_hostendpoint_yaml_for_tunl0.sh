#!/bin/bash
IP=`ip addr |grep tunl0 |grep inet|awk '{print $2}'|sed -e 's@/32@@'`
NAME=`ip addr |grep eth0  |grep inet|awk '{print $2}'|sed -e 's@/24@@'`

cat >./hostendpoint-tunl0.yaml <<EOF
apiVersion: v1
kind: hostEndpoint
metadata:
  name: tunl0
  node: $NAME
  labels:
    calico/k8s_ns: kube-system
spec:
  interfaceName: tunl0
  expectedIPs:
  - $IP
  profiles:
  - k8s_ns.kube-system
EOF
