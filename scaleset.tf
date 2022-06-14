resource "azurerm_virtual_machine_scale_set" "demolb" {
  name                = "${var.prefix}scalesetlb"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  upgrade_policy_mode  = "Manual"


  zones           = var.zones

  sku {
    name     = "Standard_DS1"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "demo"
    admin_username       = "demo"
  }

extension {
    name                 = "InstallCustomScript2"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings             = <<SETTINGS
        {
          "fileUris": ["https://raw.githubusercontent.com/AstridAlcarazEpam/ansiblerdmx4/main/apache2-install.sh"],
          "commandToExecute": "./apache2-install.sh"
        }
      SETTINGS
  }



  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }


  network_profile {
    name                                     = "networkprofile"
    primary                                  = true
    network_security_group_id                = azurerm_network_security_group.demo-instancelbvm.id

    ip_configuration {
      name                                   = "IPConfigurationlb"
      primary                                = true
      subnet_id                              = azurerm_subnet.demo-subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.demo.id]
    }
  }
}
