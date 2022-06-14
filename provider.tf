# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

# backend "azurerm" {
 #   resource_group_name  = "arquiresource02"
  #  storage_account_name = "arqustor03"
   # container_name       = "container03"
   # key                  = "terraform.tfstate"
 # }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  
  subscription_id	= "a4929585-cd69-4c28-ad1e-d0f140900663"
  tenant_id		= "41948df4-778f-4bf1-b7a6-d908919aad6a"
  client_id		= "54f37875-a819-47e3-9e73-6c47169fbe6e"
  client_secret		= "Z9SO0HEvnnc0Q-EZqgSr9GqZk8vsu4LF-L"
  
}
