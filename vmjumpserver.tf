resource "tls_private_key" "key_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.key_ssh.private_key_pem
  sensitive = true
}

#Network interface for jump server
resource "azurerm_network_interface" "demonicjump" {
  name                = "${var.prefix}-nicjump"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo-subnet2.id
    private_ip_address_allocation = "Static"
    public_ip_address_id	  = azurerm_public_ip.demo-jump.id
    private_ip_address		  = "10.0.1.15"
  }
}

#Connect the security group to the jump network interface
resource "azurerm_network_interface_security_group_association" "demo-nijump" {
    network_interface_id      = azurerm_network_interface.demonicjump.id
    network_security_group_id = azurerm_network_security_group.demo-instancelb.id
}

resource "azurerm_linux_virtual_machine" "demo-vm-jump" {
  name                = "${var.prefix}-vmjump"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = "Standard_DS1"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.demonicjump.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.key_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name = "${var.prefix}-vmjump"
  disable_password_authentication = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags={
    environment = var.tagenvironment
    deployby    = var.tagdeployby
  }
}
