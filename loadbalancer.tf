#Create Load Balancer
resource "azurerm_lb" "demo" {
   name                = "${var.prefix}-lb"
   location            = azurerm_resource_group.demo.location
   resource_group_name = azurerm_resource_group.demo.name
   sku                 = "Standard"

   frontend_ip_configuration {
     name                           = "${var.prefix}-privateipaddress"
     #private_ip_address             = "10.0.1.20"
     #public_ip_address_allocation  = "Static"
     public_ip_address_id           = azurerm_public_ip.demo-lb.id
     #subnet_id                      = azurerm_subnet.demo-subnet3.id
   }
 }

#Create Backendpool
resource "azurerm_lb_backend_address_pool" "demo" {
  name                 = "${var.prefix}BackEndAddressPool"
  loadbalancer_id      = azurerm_lb.demo.id
}

#Create Availability set
resource "azurerm_availability_set" "demo" {
  name                         = "${var.prefix}-avset"
  location                     = azurerm_resource_group.demo.location
  resource_group_name          = azurerm_resource_group.demo.name
 }


#Create the health probe
resource "azurerm_lb_probe" "demo" {
  name                = "${var.prefix}-ssh-running-probe"
  loadbalancer_id     = azurerm_lb.demo.id
  port                = 22
}

#Create the rule only for 22
resource "azurerm_lb_rule" "demo" {
  name                           = "${var.prefix}-lbrule"
  loadbalancer_id                = azurerm_lb.demo.id
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  probe_id                       = azurerm_lb_probe.demo.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.demo.id]
  frontend_ip_configuration_name = "${var.prefix}-privateipaddress"
}


#Create the health probe for mysql
resource "azurerm_lb_probe" "demomysql" {
  name                = "${var.prefix}-mysql-running-probe"
  loadbalancer_id     = azurerm_lb.demo.id
  port                = 3306
}

#Create the rule only for 3306
resource "azurerm_lb_rule" "demomysql" {
  name                           = "${var.prefix}-lbmysqlrule"
  loadbalancer_id                = azurerm_lb.demo.id
  protocol                       = "Tcp"
  frontend_port                  = 3306
  backend_port                   = 3306
  probe_id                       = azurerm_lb_probe.demomysql.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.demo.id]
  frontend_ip_configuration_name = "${var.prefix}-privateipaddress"
}


#Create the health probe for port 80
resource "azurerm_lb_probe" "demomapache" {
  name                = "${var.prefix}-apache-running-probe"
  loadbalancer_id     = azurerm_lb.demo.id
  port                = 80
}

#Create the rule only for 80
resource "azurerm_lb_rule" "demomapache" {
  name                           = "${var.prefix}-lbapacherule"
  loadbalancer_id                = azurerm_lb.demo.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  probe_id                       = azurerm_lb_probe.demomapache.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.demo.id]
  frontend_ip_configuration_name = "${var.prefix}-privateipaddress"
}
