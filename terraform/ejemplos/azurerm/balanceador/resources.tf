resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  address_space       = ["10.0.123.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.123.0/27"]
}

resource "azurerm_public_ip" "pip" {
  name                = "VIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "lb1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "fe1"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "fe1"
  probe_id                       = azurerm_lb_probe.http-probe.id
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.be_pool.id}"]
}

resource "azurerm_lb_backend_address_pool" "be_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "be"
}

resource "azurerm_network_interface_backend_address_pool_association" "be_pool_association" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.vnic.*.id[count.index]
  ip_configuration_name   = azurerm_network_interface.vnic.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.be_pool.id
}

resource "azurerm_lb_probe" "http-probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_network_interface" "vnic" {
  count               = 3
  name                = "vnic-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_specs.count
  name                = "${var.vm_specs.basename}${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_specs.size
  admin_username      = var.vm_specs.admin_username
  network_interface_ids = [
    azurerm_network_interface.vnic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.vm_specs.username
    public_key = file("${var.vm_specs.public_key}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = var.osimage_specs.name
    product   = var.osimage_specs.product
    publisher = var.osimage_specs.publisher
  }


  source_image_reference {
    publisher = var.osimage_specs.publisher
    offer     = var.osimage_specs.offer
    sku       = var.osimage_specs.sku
    version   = var.osimage_specs.version
  }
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "securitygroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "httprule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-link" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
