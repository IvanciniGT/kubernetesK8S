#!/bin/bash

kubectl create namespace nfs-provisioner

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.2.103 \
    --set nfs.path=/data/nfs \
    --set storageClass.name=cluster-nfs \
    --set storageClass.accessModes=ReadWriteOnce \
    --namespace nfs-provisioner \
    --create-namespace




cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
spec:
  storageClassName: cluster-nfs
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
EOF

kubectl delete pvc test-claim