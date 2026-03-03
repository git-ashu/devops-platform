#!/bin/bash

set -e

echo "=============================="
echo "Applying Network Stack"
echo "=============================="

cd ../infra-live/network
terraform init
terraform apply -auto-approve

echo "=============================="
echo "Applying EKS Stack"
echo "=============================="

cd ../eks
terraform init
terraform apply -auto-approve

echo "Updating kubeconfig..."
CLUSTER_NAME=$(terraform output -raw cluster_name)

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name $CLUSTER_NAME

echo "=============================="
echo "Applying Addons Stack"
echo "=============================="

cd ../addons
terraform init
terraform apply -auto-approve

echo "=============================="
echo "All stacks applied successfully"
echo "=============================="
