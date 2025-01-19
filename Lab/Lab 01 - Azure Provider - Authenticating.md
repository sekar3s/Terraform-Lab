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

**Prerequisites**

Navigate to the terraform_lab_dir where you will be writing code for your lab. Switch to Terraform lab directory in the console.

```
cd C:\Lab_Files\M07_Terraform\terraform_lab_dir
```
