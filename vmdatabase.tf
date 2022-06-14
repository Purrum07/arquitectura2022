#Database network interface for db server
resource "azurerm_network_interface" "demonicDB" {
  name                = "${var.prefix}-nicdb"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "${var.prefix}-IPConfig2"
    subnet_id                     = azurerm_subnet.demo-subnet2.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.14"
  }
}

#Connect the security group to the db network interface
resource "azurerm_network_interface_security_group_association" "demo-niDB" {
    network_interface_id      = azurerm_network_interface.demonicDB.id
    network_security_group_id = azurerm_network_security_group.demo-instancelbvm.id
}

#Create virtual machine database
resource "azurerm_linux_virtual_machine" "demo-vm-db" {
  name                = "${var.prefix}-vmdb"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = "Standard_DS1"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.demonicDB.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.key_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name = "${var.prefix}-vmdb"

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
