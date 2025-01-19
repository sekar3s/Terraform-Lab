
## Lab 01 - Azure Provider - Authenticating

In this lab, you will install and configure Terraform to prepare the environment ready for hands-on

> **Estimated Duration**: 1 hour 15 minutes

---

Terraform supports a number of different methods for authenticating to Azure:

-   Authenticating to Azure using the Azure CLI (**we will be using this method**)

-   Authenticating to Azure using Managed Service Identity

-   Authenticating to Azure using a Service Principal and a Client Certificate

-   Authenticating to Azure using a Service Principal and a Client Secret (example covered in this guide)

Terraform recommends using either a Service Principal or Managed Service Identity when running Terraform non-interactively (such as when running Terraform in a CI server) - and authenticating using the Azure CLI when running Terraform locally.

---

Terraform recommends using either a Service Principal or Managed Service Identity when running Terraform non-interactively (such as when running Terraform in a CI server) - and authenticating using the Azure CLI when running Terraform locally.

#### <ins> Setting up the Terraform provider <ins>

In Terraform there are multiple [providers](https://www.terraform.io/docs/providers/index.html). A provider is responsible for understanding API interactions and exposing resources. Terraform basically adds an abstraction layer to json ARM templates which are the payloads that Azure's API interacts. You may create, manage, and update infrastructure for building resources such as physical machines, VMs, network switches, containers, and more.

In this lab, we will, of course, be using the [Azure provider](https://www.terraform.io/docs/providers/azurerm/index.html). The following Provider block can be specified. The Azure Provider version we will use in this lab will be 4.0.0

#### <ins> Prerequisites <ins>

Navigate to the terraform_lab_dir where you will be writing code for your lab. Switch to Terraform lab directory in the console.

```
cd C:\Lab_Files\M07_Terraform\terraform_lab_dir
```

#### <ins> Service Principal <ins>

A Service Principal is an application within Azure Active Directory whose authentication tokens can be used as the client_id, client_secret, and tenant_id fields needed by Terraform (subscription_id can be independently recovered from your Azure account details).

It's possible to complete this task in either the Azure CLI or in the Azure Portal - For the purpose of this lab, we will simply authenticate with our user credentials. However, it is important to note that authenticating via a Service Principal with a client secret which has the minimum rights needed to the subscription is the standard authentication method for an automation pipeline.

**NOTE: You will need both CLI and Powershell versions for this lab.**

#### <ins> Install Azure CLI <ins>

1.  Navigate [here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) for installation instructions.

#### <ins>  Login to azure Powershell Az <ins>

1.  Open a new Command Prompt session as an “Administrator” user. NOTE: Administrator privileges are necessary to perform the installation of modules below.

2.  Run
   ```
Install-Module -Name Az
```

