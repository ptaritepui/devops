#!/bin/bash
echo "Inicializando terraform"
terraform -chdir=./terraform init
echo "Creando infraestructura con Terraform"
terraform -chdir=./terraform apply -auto-approve
echo "Creando el fichero de inventario de Ansible"
bash terraform/create_inventory_file.sh
echo "Ejecutando los cambios de configuracion con Ansible"
bash ansible/deploy.sh
