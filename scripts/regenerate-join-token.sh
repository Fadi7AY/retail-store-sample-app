#!/bin/bash
# scripts/regenerate-join-token.sh
set -e

echo "[*] Generating new join token..."
JOIN_CMD=$(kubeadm token create --print-join-command)
echo "${JOIN_CMD}" | sudo tee /tmp/kubeadm-join.sh
sudo chmod +x /tmp/kubeadm-join.sh

TOKEN=$(echo "${JOIN_CMD}" | grep -oP 'token \K[^\s]+')
CA_CERT_HASH=$(echo "${JOIN_CMD}" | grep -oP 'discovery-token-ca-cert-hash \K[^\s]+')
CONTROL_PLANE_IP=$(hostname -I | awk '{print $1}')

echo "========================================="
echo "[*] New join token generated!"
echo ""
echo "Token: ${TOKEN}"
echo "CA Cert Hash: ${CA_CERT_HASH}"
echo "Control Plane IP: ${CONTROL_PLANE_IP}:6443"
echo ""
echo "Join command:"
echo "${JOIN_CMD}"
echo ""
echo "Join script saved at: /tmp/kubeadm-join.sh"
echo "========================================="
