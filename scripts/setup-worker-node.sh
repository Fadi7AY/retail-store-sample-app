#!/bin/bash
# scripts/setup-worker-node.sh
set -e

if [ ! -f /tmp/kubeadm-join.sh ]; then
  echo "ERROR: /tmp/kubeadm-join.sh not found."
  echo ""
  echo "To generate the join command on the control-plane node, run:"
  echo "  kubeadm token create --print-join-command | sudo tee /tmp/kubeadm-join.sh"
  echo ""
  echo "Then copy /tmp/kubeadm-join.sh to this node at the same path."
  exit 1
fi

echo "[*] Joining node to cluster..."
sudo bash /tmp/kubeadm-join.sh

echo "========================================="
echo "[*] Worker joined successfully!"
echo "[*] Verify on control plane with: kubectl get nodes"
echo "========================================="