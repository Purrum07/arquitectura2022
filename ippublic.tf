#Create public ip for jump server
resource "azurerm_public_ip" "demo-jump" {
  name                = "${var.prefix}-publicipjump"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}

#Create public ip for loadbalancer
resource "azurerm_public_ip" "demo-lb" {
  name                = "${var.prefix}-public-iplb"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.demo.name
  sku                 = "Standard"

  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}
