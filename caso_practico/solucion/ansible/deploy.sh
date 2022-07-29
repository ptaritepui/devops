#!/bin/bash
echo "Ejecutando la instalación y configuracion de Kubernetes"
ansible-playbook -i ansible/hosts ansible/00_kubernetes_setup.yaml
echo "Desplegando una aplicacion persistente sobre Kubernetes"
ansible-playbook -i ansible/hosts ansible/01_app_setup.yaml
