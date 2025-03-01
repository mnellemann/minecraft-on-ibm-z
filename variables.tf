# Project Variables

variable "name" {
  description = "Basename to prefix resources."
  type        = string
  default     = "minecraft"
}

variable "api_key" {
  description = "IBM Cloud API Key"
  sensitive   = true
  type        = string
}

variable "ssh_key" {
  description = "Existing SSH Key ID"
  default = "mark-x1"
}

 variable "minecraft_port" {
  description = "Minecraft server port number"
  default = 25565
 }
