output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}
