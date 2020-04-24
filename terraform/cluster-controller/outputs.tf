output "kube_pub_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "resource_group_name" {
  value = azurerm_virtual_network.main.resource_group_name
}

output "resource_location" {
  value = azurerm_virtual_network.main.location
}
