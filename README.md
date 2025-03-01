Minecraft Server on IBM Z 
==========================

Infrastructure as Code with Terraform.


## Prequisites

1. IBM Cloud Account
2. Login and create an API Key


## Configuration

1. Run `terraform init`

[Take care to store](https://spacelift.io/blog/terraform-state) the **terraform.tfstate** file, as this file is needed when you apply or destroy your infrastructure.

## Plan & Apply

Ensure you provide the API Key:

```
export IC_API_KEY=<your api key>
export TF_VAR_api_key=$IC_API_KEY
```

Optionally provide your own *environment* name to support multiple installation within same Cloud account.

export TF_VAR_prefix=minecraft-2


1. Run `terraform plan`
2. Run `terraform apply`
