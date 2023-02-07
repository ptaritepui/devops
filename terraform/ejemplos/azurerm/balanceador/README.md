# Procedimiento para desplegar un balanceador de carga:

El siguiente ejemplo crea a través de Terraform la infraestructura necesaria para disponer de un balanceador de carga hacia múltiples servidores web:

1. Instalar el proveedor de Terraform para Azure:
`terraform init`
2. Desplegar las máquinas virtuales y el balanceador de carga:
`terraform apply --auto-approve`
3. Configurar las máquinas virtuales como servidores web:
`./00_run_script.sh`
4. Verificar la connectividad al balanceador:
`curl -v http://<VIP>`
