#!/bin/bash
kubeadm token create --print-join-command


#echo kubectl label nodes worker1 mariadb=true