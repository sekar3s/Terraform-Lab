
## Lab 02 - Managing Terraform State on Azure

In this lab, you will install and configure Terraform to prepare the environment ready for hands-on

> **Estimated Duration**: 1 hour

---

Terraform state is used to reconcile deployed resources with Terraform configurations. Using state, Terraform knows what Azure resources to add, update, or delete. By default, Terraform state is stored locally when running *Terraform apply*. This configuration is not ideal for a few reasons:

-   Local state does not work well in a team or collaborative environment

-   Terraform state can include sensitive information

-   Storing state locally increases the chance of inadvertent deletion

Centralizing your state file is a solution. In this lab, we will be doing just that. A common solution is to place your state file in an Azure Blob Storage Account that is locked down to the bare minimum. It is important to lock this down because Terraform prints out your state as is. This may include sensitive resource data like passwords. Also, please note that terraform supports state locking and consistency checking via native capabilities of Azure Blob Storage. This ensures there are no conflicts if multiple processes to terraform apply were to run.

**Create the Storage Account and store the access key in key vault**

Before using Azure Storage as a backend, a storage account must be created. The storage account can be created with the Azure portal, PowerShell, the Azure CLI, or Terraform itself. In this lab, we will deploy through the Azure CLI.

In this lab, there is a helper script that will

-   create a storage account named *terraformstate* followed by a random string

-   create a container in the account named *terraformstate* (**Note:** we can create different containers to host terraform states for different environments like production, stage, etc.)

-   create a key vault named *terraform-kv-* followed by the same random string as the storage account

-   set access policies to the key vault for the account associated to the email given as input and application id given as input

-   create a key vault secret with the name *ARM-ACCESS-KEY* and value of the storage account access key

-   stores information to be used throughout the lab in a file at `terraform_lab_dir\lab_output_logs\remote_backend.log`

**NOTE:** We can certainly place the storage account access key in a tfvars file as we did with the client secret in providers.tfvars. However, in this lab, we will show you a more secure option in which the secret only lives locally during the lifetime of your powershell session.

#### <ins> Lab 02 Steps <ins>

1.  Navigate to the terraform_lab_dir where you will be writing code for your lab.

[Launch the VS Code Terminal/Powershell session now and run the commands within the VS code]

```console
cd C:\Lab_Files\M07_Terraform\terraform_lab_dir
```

2.  Replace the entire content of file in `.\helper_scripts\set_remote_backend.ps1` with the content from the github file below

<https://github.com/sekar3s/Terraform-Lab/blob/main/set_remote_backend.ps1>

3.  [Login to azure (Azure CLI)](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-interactively)

4.  [Login to azure Powershell Az](https://learn.microsoft.com/en-us/powershell/azure/authenticate-interactive) (The script in the next step requires to run a mix of azure cli and azure powershell commands)

5.  In the terminal, **run** the script found at this location `.\helper_scripts\set_remote_backend.ps1` with the following parameters shown followed by parameters (remember to place double quotes) -adminEmail "<insert the email account you use to login to the Azure subscription>" -resource_group_name "<Insert the name of the existing resource group. This value is assigned to rg_name in ./providers.tfvars>". Below is an example of how this command will look like:

```console
.\helper_scripts\set_remote_backend.ps1 -adminEmail "joesmith@contoso.com" -resource_group_name "myrg"
```

Select **[R] Run once** option. You should see output like the following

```json
Checking for an active Azure login..............................................SUCCESS!

Creating Storage Account [terraformstate044330] and Container [terraformstate]...

SUCCESS!

Creating Terraform KeyVault: [terraform-kv-044330].............................SUCCESS!

Setting KeyVault Access Policy for Admin User: [joesmith@contoso.com]........SUCCESS!

Setting KeyVault Access Policy for Terraform SP with appid: [xxxx-4444-439a-lkj4-afa6f0983jrec]...SUCCESS!

Creating KeyVault Secret(s) for Terraform......................................SUCCESS!

Writing output to .\lab_output_logs\remote_backend.log
```

6.  When the script completes, it will have written information about the storage account and key vault in .\\lab_output_logs\\remote_backend.log so that you can reference the information throughout the lab. (Please disregard that the storage access_key value is stored in this file which defeats the whole purpose of the lab. It is simply there for easy referencing)

7.  Open the file `.\lab_output_logs\remote_backend.log` through VS code to see the contents

