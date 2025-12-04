#!/bin/bash
set -e

if [ ! -f /tmp/kubeadm-join.sh ]; then
  echo "ERROR: /tmp/kubeadm-join.sh not found. Copy it from the control-plane node."
  exit 1
fi

echo "[*] Joining node to cluster..."
sudo bash /tmp/kubeadm-join.sh

echo "[*] Worker joined successfully."
