# Project Outputs

#output "vpc" {
#    description = "VPC Name"
#    value = ibm_is_vpc.name
#}

# Display information for logging into our virtual server through SSH
output "ssh-command" {
   value = "ssh root@${ibm_is_floating_ip.this.address}"
}


# Display the hostname and port of your Minecraft server, which you would
# enter into Multiplayer -> Direct Connect when running the game.
output "minecraft-server" {
   value = "Minecraft Multiplayer Direct Connect: ${ibm_is_floating_ip.this.address}:${var.minecraft_port}"
}
