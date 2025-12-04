#!/bin/bash
set -e

POD_CIDR="192.168.0.0/16"  # Calico default

echo "[*] Initializing control plane..."
sudo kubeadm init \
  --pod-network-cidr=${POD_CIDR} \
  --apiserver-advertise-address=0.0.0.0

echo "[*] Configuring kubectl for user $(whoami)..."
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[*] Installing Calico CNI..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml

echo "[*] Generating join command..."
kubeadm token create --print-join-command | sudo tee /tmp/kubeadm-join.sh
sudo chmod +x /tmp/kubeadm-join.sh

echo "[*] Control plane ready. Join script at /tmp/kubeadm-join.sh"
