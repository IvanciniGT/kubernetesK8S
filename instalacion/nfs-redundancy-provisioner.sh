#!/bin/bash

kubectl create namespace nfs-redundant-provisioner

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update
helm install nfs-redundant-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.2.102 \
    --set nfs.path=/data/nfs \
    --set storageClass.name=cluster-redundant-nfs \
    --set storageClass.accessModes=ReadWriteOnce \
    --namespace nfs-redundant-provisioner \
    --create-namespace




cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
spec:
  storageClassName: cluster-redundant-nfs
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
EOF

kubectl delete pvc test-claim