
## Lab 04 - Deploying (Additional) Resources

In this lab, you will learn how to create terraform modules that can be reused while deploying resources in multiple environments *(dev/prod/staging)*.

In this lab, we will learn how to deploy Azure Resources using basic Terraform mechanics. We will learn how to use Terraform's [depends_on](https://www.terraform.io/docs/configuration/resources.html#depends_on-explicit-resource-dependencies) meta-argument, [provisioner](https://www.terraform.io/docs/provisioners/index.html) types, [data](https://www.terraform.io/docs/configuration/data-sources.html) sources all while securing our secrets in Key Vault.

#### <ins> Prerequisites <ins>

1.  We will create these resources in our *dev* environment. Run

```console
terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=$env:ARM_ACCESS_KEY"
```

2.  If you haven't run this at the end of DIY challenge already, run the below command to destroy your target infrastructure generated from the challenge.

```console
terraform destroy -var-file="providers.tfvars"
```

> **Estimated Duration**: 1 hour 30 minutes

---

#### <ins> What is a Module <ins>