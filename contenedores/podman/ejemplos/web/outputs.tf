output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_user" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_pass" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "vm_public_ip" {
  value = azurerm_public_ip.pip_vm.ip_address
}

output "ssh_user" {
  value = var.ssh_user
}
