#!/bin/bash

if [ $# != 1 ];then
	echo "usage: $0 TargetNamespace"
	exit 1
fi

for pod in `kubectl -n $1 get pod -o name`;do
	kubectl -n $1 get $pod -o=go-template="{{ range .spec.containers }}{{ .image }}{{ end }}"
	echo ""
done
