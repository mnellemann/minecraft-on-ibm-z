# Project Providers

# Use a recent version of the IBM Cloud provider for Terraform
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.75.0"
    }
  }
}

# Configure the IBM Provider
# https://registry.terraform.io/providers/IBM-Cloud/ibm/latest
provider "ibm" {
  region = local.REGION
  // ibmcloud_api_key = ""
}
