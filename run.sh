#!/bin/bash

pushd ./calico-ip-conflict
./run.sh
bash ./pod.rebuild.sh
popd

pushd ./calico-ipam-reset
./run.sh
popd

pushd ./k8s-ip-monitor
./run.sh
popd
