#!/bin/bash


echo " " >> ../ansible/inventory
echo "[kubecontrol]" >> ../ansible/inventory
echo $(terraform output kube_pub_ip) >> ../ansible/inventory

echo " " >> ../ansible/inventory

echo "[kubecontrol:vars]" >> ../ansible/inventory
echo "ansible_user=mizan" >> ../ansible/inventory
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../ansible/inventory
echo "ansible_ssh_private_key_file=~/.ssh/id_rsa" >> ../ansible/inventory
