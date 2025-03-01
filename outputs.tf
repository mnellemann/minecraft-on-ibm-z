# Project Outputs

#output "vpc" {
#    description = "VPC Name"
#    value = ibm_is_vpc.name
#}

# Try to logon to the Virtual Service Instance
output "ssh-command" {
   value = "ssh root@${ibm_is_floating_ip.this.address}"
}


output "minecraft-server" {
   value = "Minecraft server running on ${ibm_is_floating_ip.this.address} port ${var.minecraft_port}"
}
