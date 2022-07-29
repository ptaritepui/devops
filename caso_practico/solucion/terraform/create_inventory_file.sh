#!/bin/bash
terraform -chdir=terraform refresh
terraform -chdir=terraform output -json > output.json
MASTER_INT_IP=$(cat output.json | jq '.k8s_private_ips.value[0][0]' |  sed s/\"//g)
MASTER_PUB_IP=$(cat output.json | jq '.k8s_public_ips.value[0][0]' |  sed s/\"//g)
WORKER_INT_IP=$(cat output.json | jq '.k8s_private_ips.value[0][1]' |  sed s/\"//g)
WORKER_PUB_IP=$(cat output.json | jq '.k8s_public_ips.value[0][1]' |  sed s/\"//g)
NFS_INT_IP=$(cat output.json | jq '.nfs_private_ip.value' |  sed s/\"//g)
NFS_PUB_IP=$(cat output.json | jq '.nfs_public_ip.value' |  sed s/\"//g)

cat <<EOF > ansible/hosts
[masters]
${MASTER_PUB_IP} domain_name=master.example.com internal_ip=${MASTER_INT_IP}

[workers]
${WORKER_PUB_IP} domain_name=worker01.example.com internal_ip=${WORKER_INT_IP}

[nfss]
${NFS_PUB_IP} domain_name=nfs.example.com internal_ip=${NFS_INT_IP}

[kubernetes:children]
masters
workers
EOF
rm -rf output.json
