variable "resource_group_name" {
  default = "rg-casopractico2"
}

variable "location_name" {
  default = "uksouth"
}

variable "network_name" {
  default = "vnet1"
}

variable "subnet_name" {
  default = "subnet1"
}

variable "vm_count" {
  default = 2
}

variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "uksouth" 
}

variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "storage_account"
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub" 
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "casopractico"
}
