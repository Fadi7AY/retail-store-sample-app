#!/bin/bash
# scripts/setup-control-plane.sh
set -e

POD_CIDR="192.168.0.0/16"  # Calico default
NODE_IP=$(hostname -I | awk '{print $1}')

echo "[*] Initializing control plane..."
sudo kubeadm init \
  --pod-network-cidr=${POD_CIDR} \
  --apiserver-advertise-address=${NODE_IP}

echo "[*] Configuring kubectl for user $(whoami)..."
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[*] Installing Calico CNI..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml

echo "[*] Waiting for Calico pods to be ready..."
kubectl wait --for=condition=ready pod -l k8s-app=calico-node -n calico-system --timeout=300s || true

echo "[*] Allowing workloads on control plane (for single-node setup)..."
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

echo "[*] Setting up ECR credentials..."
AWS_ACCOUNT_ID="992824239500"
AWS_REGION="eu-west-2"

if command -v aws &> /dev/null; then
    kubectl create secret docker-registry ecr-registry-secret \
      --docker-server=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com \
      --docker-username=AWS \
      --docker-password=$(aws ecr get-login-password --region ${AWS_REGION}) \
      --namespace=default || echo "Secret already exists"

    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "ecr-registry-secret"}]}' || true
else
    echo "[!] AWS CLI not found. Skipping ECR setup. You'll need to configure it manually."
fi

echo "[*] Generating join command and token..."
JOIN_CMD=$(kubeadm token create --print-join-command)
echo "${JOIN_CMD}" | sudo tee /tmp/kubeadm-join.sh
sudo chmod +x /tmp/kubeadm-join.sh

# Extract token and discovery token ca cert hash for manual use
TOKEN=$(echo "${JOIN_CMD}" | grep -oP 'token \K[^\s]+')
CA_CERT_HASH=$(echo "${JOIN_CMD}" | grep -oP 'discovery-token-ca-cert-hash \K[^\s]+')

echo "[*] Join command details:"
echo "  Token: ${TOKEN}"
echo "  CA Cert Hash: ${CA_CERT_HASH}"
echo "  Control Plane IP: ${NODE_IP}"

echo "[*] Verifying cluster..."
kubectl get nodes
kubectl get pods -A

echo "========================================="
echo "[*] Control plane ready!"
echo "[*] Join script saved at: /tmp/kubeadm-join.sh"
echo ""
echo "To join worker nodes, run ONE of these methods:"
echo ""
echo "Method 1 - Copy join script:"
echo "  scp /tmp/kubeadm-join.sh user@worker-node:/tmp/"
echo "  ssh worker-node 'sudo bash /tmp/kubeadm-join.sh'"
echo ""
echo "Method 2 - Manual join command:"
echo "  ${JOIN_CMD}"
echo ""
echo "Method 3 - Generate new token (if expired):"
echo "  kubeadm token create --print-join-command"
echo "========================================="
