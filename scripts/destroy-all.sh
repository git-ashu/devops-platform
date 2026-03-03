#!/bin/bash

set -e

echo "=============================="
echo "Destroying Addons Stack"
echo "=============================="

cd ../infra-live/addons
terraform destroy -auto-approve

echo "=============================="
echo "Destroying EKS Stack"
echo "=============================="

cd ../eks
terraform destroy -auto-approve

echo "=============================="
echo "Destroying Network Stack"
echo "=============================="

cd ../network
terraform destroy -auto-approve

echo "=============================="
echo "All stacks destroyed cleanly"
echo "=============================="
