#!/bin/sh
# This script is waiting until LoadBalancer service be ready
# then generates token and records it into Kubernetes secret
#
# Usage: gentoken.sh <serviceName> <secretName>

set -e

SVC=${1:-$SVC}
SECRET=${2:-$SECRET}

getip(){
  kubectl get service -w "$1" -o 'go-template={{with .status.loadBalancer.ingress}}{{range .}}{{.ip}}{{"\n"}}{{end}}{{.err}}{{end}}' 2>/tmp/error | head -n1
}

echo "Waiting for svc/$SVC"
IP=$(getip "$SVC")
if [ -z "$IP" ]; then
  cat /tmp/error
  exit 1
fi

echo "Acquiring token"
kubeadm --kubeconfig /etc/kubernetes/admin.conf token create --description kubefarm --print-join-command > /tmp/token

SOURCE_FILE="/etc/ignition.yaml"
WORKFILE="/tmp/ignition.yaml"

cp ${SOURCE_FILE} ${WORKFILE}

cat <<EOT >> ${WORKFILE}
    #
    # Kubernetes Join Config
    #
    - path: /etc/kubeadm-join.conf
      filesystem: root
      contents:
        inline: |
          HOSTS_KUBERNETES="${IP} $(awk -F'[ :]' '{print $3}' /tmp/token)"
          JOIN_COMMAND="$(cat /tmp/token)"
      mode: 0777
EOT



MAIN_FILE="$(cat ${WORKFILE})"
SECRET_BASE64=$(echo "$CONFIG" | base64 | tr -d '\n')

echo "MainFile ${MAIN_FILE}"



