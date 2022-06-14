#Create virtual network
resource "azurerm_virtual_network" "demovnet" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.tagenvironment
    deployby	= var.tagdeployby
  }
}

#Create subnet1
resource "azurerm_subnet" "demo-subnet1"{
  name		= "${var.prefix}-subnet1"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demovnet.name
  address_prefixes	= ["10.0.0.0/24"]

}

#Create subnet2
resource "azurerm_subnet" "demo-subnet2"{
  name		= "${var.prefix}-subnet2"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demovnet.name
  address_prefixes	= ["10.0.1.0/24"]

}
#Create subnet3
resource "azurerm_subnet" "demo-subnet3"{
  name		= "${var.prefix}-subnet3"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demovnet.name
  address_prefixes	= ["10.0.2.0/24"]

}

#Create network security group for agvm
resource "azurerm_network_security_group" "demo-instance" {
    name                = "${var.prefix}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.demo.name


    security_rule {
        name                       = "HTTPS"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

 

    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


    security_rule {
        name                       = "SSH"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix    = var.ssh-source-address
        destination_address_prefix = "VirtualNetwork"
    }


    security_rule {
        name                       = "denyrule"
        priority                   = 1021
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}

#Create network security group for lbvm
resource "azurerm_network_security_group" "demo-instancelb" {
    name                = "${var.prefix}-nsglb"
    location            = var.location
    resource_group_name = azurerm_resource_group.demo.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
    }

     security_rule {
        name                       = "denyrule"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}

#Create network security group for lbvm
resource "azurerm_network_security_group" "demo-instancelbvm" {
    name                = "${var.prefix}-nsglbvm"
    location            = var.location
    resource_group_name = azurerm_resource_group.demo.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix    = var.ssh-source-address
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name                       = "load"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "VirtualNetwork"
    }


    security_rule {
        name                       = "MYSQL"
        priority                   = 1012
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix    = var.ssh-source-address
        destination_address_prefix = "VirtualNetwork"
    }


    security_rule {
        name                       = "MYSQL2"
        priority                   = 1020
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix    = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }


    security_rule {
        name                       = "denyrule"
        priority                   = 1022
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Port_80"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

  tags={
  environment = var.tagenvironment
  deployby    = var.tagdeployby
  }
}
