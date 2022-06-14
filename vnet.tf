resource "azurerm_virtual_network" "arquivnet" {
  name                = "arquivnet"
  location            = azurerm_resource_group.demoresourcegroup.location
  resource_group_name = azurerm_resource_group.demoresourcegroup.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.arquisecuritygroup.id
  }

  tags = {
    environment = "Production"
  }
}
