variable "resource_group_name" {
  default = "azure-ej-lb"
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

variable "vm_specs" {
  type = object({
    count          = number
    basename       = string
    size           = string
    admin_username = string
    username       = string
    public_key      = string
  })

  sensitive = true

  default = {
    count          = 3
    basename       = "vm0"
    size           = "Standard_B1s"
    admin_username = "azureuser"
    username       = "azureuser"
    public_key     = "~/.ssh/id_rsa.pub"
  }
}

variable "osimage_specs" {
  type = object({
    name      = string
    product   = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    name      = "8_5"
    product   = "almalinux"
    publisher = "almalinux"
    offer     = "almalinux"
    sku       = "8_5"
    version   = "8.5.20220311"
  }
}
