output "k8s_public_ips" {
  value = ["${azurerm_public_ip.pip.*.ip_address}"]
}

output "nfs_public_ip" {
  value = azurerm_public_ip.pip_nfs.ip_address
}

output "nfs_private_ip" {
  value = azurerm_network_interface.nic_nfs.private_ip_address
}

output "k8s_private_ips" {
  value = ["${azurerm_network_interface.nic.*.private_ip_address}"]
}
