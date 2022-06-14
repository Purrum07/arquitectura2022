#Create Resource group
resource "azurerm_resource_group" "demo" {
  name     = "${var.prefix}-resourcegroup"
  location = var.location

  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}
