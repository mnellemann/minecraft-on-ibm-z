# Project Variables

variable "prefix" {
  description = "Prefix resources with this."
  type        = string
  default     = "minecraft"
}

variable "region" {
  description = "IBM Cloud Region"
  default = "eu-de"
}

variable "zone" {
  description = "IBM Cloud Zone"
  default =   "eu-de-2"
}

variable "api_key" {
  description = "IBM Cloud API Key"
  sensitive   = true
  type        = string
}

variable "minecraft_port" {
  description = "Minecraft server port number"
  default = 25565
}

variable "ssh_key" {
  description = "Existing SSH Key ID in your IBM Cloud Account"
  default = "mark-x1"
}
