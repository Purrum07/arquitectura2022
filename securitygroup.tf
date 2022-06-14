resource "azurerm_network_security_group" "arquisecuritygroup" {
  name                = "arquisecuritygroup"
  location            = azurerm_resource_group.demoresourcegroup.location
  resource_group_name = azurerm_resource_group.demoresourcegroup.name
}
