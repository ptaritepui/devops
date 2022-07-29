resource "azurerm_network_interface" "nic_nfs" {
  name                = "vnic-nfs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_nfs.id
  }
}

resource "azurerm_public_ip" "pip_nfs" {
  name                = "public-ip-nfs"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}


resource "azurerm_linux_virtual_machine" "vm_nfs" {
  name                = "vm-nfs"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.ssh_user
  network_interface_ids = [
    azurerm_network_interface.nic_nfs.id,
  ]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }


  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }
}

resource "azurerm_managed_disk" "data_nfs" {
  name                 = "data-nfs"
  location             = azurerm_resource_group.rg.location
  create_option        = "Empty"
  disk_size_gb         = 50
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_nfs" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm_nfs.id
  managed_disk_id    = azurerm_managed_disk.data_nfs.id
  lun                = 0
  caching            = "None"
}
