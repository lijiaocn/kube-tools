#!/bin/bash
for node in `kubectl get node  -o go-template="{{ range .items }} {{ index .status.addresses 1 \"address\" }} {{end}}"`;do
    ip=`kubectl get node $node -o go-template="{{ index .status.addresses 0 \"address\" }}"`
    tunnel=`./get_host_tunnel_ip.sh $node`
    echo $node $ip $tunnel
cat >/tmp/hostendpoint.yaml <<EOF
apiVersion: v1
kind: hostEndpoint
metadata:
  name: eth0
  node: $node
  labels:
    calico/k8s_ns: kube-system
spec:
  interfaceName: eth0
  expectedIPs:
  - $ip
  - $tunnel
  profiles:
  - k8s_ns.kube-system
EOF
calicoctl create -f /tmp/hostendpoint.yaml
done
calicoctl get hostendpoint -o wide
