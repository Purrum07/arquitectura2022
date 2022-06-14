#Variables
variable "prefix" {
  type    = string
  default = "arqui01terraform"
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "tagenvironment"{
  type	= string
  default = "demo"
}

variable "tagdeployby"{
  type	= string
  default = "adminmario"
}

variable "ssh-source-address"{
  type = string
  default = "10.0.1.15"
}

variable "zones" {
  type = list(string)
  default = []
}
