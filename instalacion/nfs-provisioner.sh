#!/bin/bash

kubectl create namespace nfs-provisioner-ivan

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=172.31.11.35 \
    --set nfs.path=/data/nfs \
    --set storageClass.name=cluster-nfs-ivan \
    --set storageClass.accessModes=ReadWriteOnce \
    --set nfs.reclaimPolicy=Retain \
    --namespace nfs-provisioner-ivan \
    --create-namespace


helm template nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=172.31.11.35 \
    --set nfs.path=/data/nfs \
    --set storageClass.name=cluster-nfs-ivan \
    --set storageClass.accessModes=ReadWriteOnce \
    --set nfs.reclaimPolicy=Retain \
    --namespace nfs-provisioner-ivan \
    --create-namespace > provisionador.yaml





cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim-ivan
spec:
  storageClassName: cluster-nfs-ivan
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
EOF

#kubectl delete pvc test-claim-ivan