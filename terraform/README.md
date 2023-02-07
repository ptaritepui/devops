# Terraform
Este directorio incluye ejemplo básicos de despliegue de infraestructura como código (IaC) mediante Terraform.

## Utilización de Terraform en Azure

### Requisitos

* Una suscripción válida en Azure.

* Terraform versión **0.14.9** o superior.

* Azure CLI instalado.

## Casos de uso de Terraform en Azure

* [Crear una máquina virtual con sistema operativo Ubuntu](ejemplos/azurerm/vm_ubuntu)
* [Crear una máquina virtual basada en CentOS Stream desde el marketplace de Azure](ejemplos/azurerm/vm_centos_stream)
* [Crear una máquina virtual con dos discos: arranque + datos](ejemplos/azurerm/multiples_discos)
* [Crear un balanceador de carga hacia múltiples servidores web](ejemplos/azurerm/balanceador)


El siguiente [enlace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) proporciona mayor información sobre estos y otros casos de uso de Terraform en Azure.
