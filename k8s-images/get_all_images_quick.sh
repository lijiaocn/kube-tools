#!/bin/bash

if [ $# != 1 ];then
	echo "usage: $0 TargetNamespace"
	exit 1
fi

kubectl -n $1 get pod -o=go-template='{{ define "getimage" }}{{ range .spec.containers }}{{ .image }}\n{{end}}{{ end }}{{ range .items }}{{ template "getimage" . }}{{ end }}' |sed -e "s@\\\n@\n@g"
