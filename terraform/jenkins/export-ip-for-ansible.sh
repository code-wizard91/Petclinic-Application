#!/bin/bash

echo "[jenkins]" > ../ansible/inventory
echo $(terraform output jenkins_ip) >> ../ansible/inventory

echo " " >> ../ansible/inventory

echo "[jenkins:vars]" >> ../ansible/inventory
echo "ansible_user=mizan" >> ../ansible/inventory
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../ansible/inventory
echo "ansible_ssh_private_key_file=~/.ssh/id_rsa" >> ../ansible/inventory


