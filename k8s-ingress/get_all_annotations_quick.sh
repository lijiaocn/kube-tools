#!/bin/bash

if [ $# != 1 ];then
	echo "usage: $0 TargetNamespace"
	exit 1
fi

if [[ "$1"=="all" ]];then
	kubectl get ingress --all-namespaces -o go-template='{{range .items}}{{ range $key,$value:=.metadata.annotations }}{{ $key }}:{{ $value}}\n{{end}}\n\n{{ end }}' |sed -e "s@\\\n@\n@g"
else
	kubectl get ingress -n $1 -o go-template='{{range .items}}{{ range $key,$value:=.metadata.annotations }}{{ $key }}:{{ $value}}\n{{end}}\n\n{{ end }}' |sed -e "s@\\\n@\n@g"
fi
