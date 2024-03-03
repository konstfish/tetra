# tetra
Part of [infra.konst.fish](https://github.com/konstfish/infra.konst.fish)

Create a Kubernetes Cluster on Hetzner Cloud

## Variables
Defaults are pretty sensible, see [./variables.tf](./variables.tf) & [./terraform.tfvars](./terraform.tfvars)

## Usage
```
export TF_VAR_hcloud_token="xxx"
export TF_VAR_cloudflare_api_token="xxx"
export TF_VAR_cloudflare_acount_id="xxx"

terraform init
terraform plan
terraform apply
```
