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

## Recursos básicos de Terraform en Azure

* [Azure Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)

* [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

* [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)

* [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)

* [Azure Network Security Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)

* [Azure Network Security Rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule)

* [Azure Linux Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

* [Azure Container Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)

* [Azure Kubernetes Cluster (AKS)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
