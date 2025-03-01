###
### General
###

# Locals and variables
locals {
   BASENAME = var.name
   REGION   = "eu-de"
   ZONE     = "eu-de-2"
}

# Existing SSH key can be provided
data "ibm_is_ssh_key" "ssh_key_id" {
   name = var.ssh_key
}


# IBM Cloud Resource Group
resource "ibm_resource_group" "this" {
  name     = var.name
}



###
### Virtual Private Cloud (VPC)
###


resource "ibm_is_vpc" "this" {
  name = "${local.BASENAME}-vpc"
}

# Security group
resource "ibm_is_security_group" "this" {
   name = "${local.BASENAME}"
   vpc  = ibm_is_vpc.this.id
}

# allow all incoming network traffic on port 22
resource "ibm_is_security_group_rule" "ingress_ssh_all" {
   group     = ibm_is_security_group.this.id
   direction = "inbound"
   remote    = "0.0.0.0/0"

   tcp {
     port_min = 22
     port_max = 22
   }
}

# allow all incoming network traffic on port 25565
resource "ibm_is_security_group_rule" "ingress_minecraft_all" {
   group     = ibm_is_security_group.this.id
   direction = "inbound"
   remote    = "0.0.0.0/0"

   tcp {
     port_min = var.minecraft_port
     port_max = var.minecraft_port
   }
}


# allow all outgoing network traffic
resource "ibm_is_security_group_rule" "egress_all" {
   group     = ibm_is_security_group.this.id
   direction = "outbound"
   remote    = "0.0.0.0/0"
}


# Subnet
resource "ibm_is_subnet" "this" {
   name                     = "${local.BASENAME}-subnet"
   vpc                      = ibm_is_vpc.this.id
   zone                     = local.ZONE
   total_ipv4_address_count = 256
}



###
### Virtual Server Instance (VSI)
###

# Image for Virtual Server Insance
data "ibm_is_image" "ubuntu" {
   name = "ibm-ubuntu-22-04-4-minimal-s390x-3"
}


# Virtual Server Insance
resource "ibm_is_instance" "this" {
   name    = "${local.BASENAME}-vsi1"
   vpc     = ibm_is_vpc.this.id
   keys    = [ data.ibm_is_ssh_key.ssh_key_id.id ]
   zone    = local.ZONE
   image   = data.ibm_is_image.ubuntu.id
   profile = "bz2-1x4"

   # References to the subnet and security groups
   primary_network_interface {
     subnet          = ibm_is_subnet.this.id
     security_groups = [ibm_is_security_group.this.id]
   }

  user_data = file("mc_install.sh")
  #user_data = <<-EOL
  #!/bin/bash -xe
  #apt update
  #apt install openjdk-21-jre-headless git curl wget --yes
  #EOL
}

# Request a foaling ip
resource "ibm_is_floating_ip" "this" {
   name   = "${local.BASENAME}-fip"
   target = ibm_is_instance.this.primary_network_interface[0].id
}




