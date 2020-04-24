# configure the Azure Provider
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

#create resource group
resource "azurerm_resource_group" "main" {
  name     = "kube-controller"
  location = "eastus"
}

#create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "kube-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

#create subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

#create public IP
resource "azurerm_public_ip" "main" {
  name                = "kube-publicIp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"

}

#create NIC
resource "azurerm_network_interface" "main" {
  name                = "kube-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

#Create VM
resource "azurerm_virtual_machine" "main" {
  name                  = "kube-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "kube-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  provisioner "file" {
    source      = "~/.ssh/id_rsa.pub"
    destination = "public_key"

    connection {
      type        = "ssh"
      user        = var.admin_username
      host        = azurerm_public_ip.main.ip_address
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
