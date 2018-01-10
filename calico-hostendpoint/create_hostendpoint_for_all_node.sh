#!/bin/bash
for i in `kubectl get node -o go-template="  "`
do
    echo $i
cat >/tmp/hostendpoint.yaml <<EOF
apiVersion: v1
kind: hostEndpoint
metadata:
  name: eth0
  node: $i
  labels:
    calico/k8s_ns: kube-system
spec:
  interfaceName: eth0
  expectedIPs:
  - $i
  profiles:
  - k8s_ns.kube-system
EOF
calicoctl create -f /tmp/hostendpoint.yaml
done
