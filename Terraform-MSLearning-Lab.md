**MakdTerraform Lab**

**Total Duration - 8 Hours**

**Pre-requisites**

1.  **Launch the Virtual**

2.  **This document will replace the instructions you will under the “Instructions” tab/pane of the lab**

3.  

**Terraform and Azure**

**Overview**

In this lab, you will exercise hands-on labs with Terraform. You will learn how to authenticate with Terraform's Azure Provider, manage Terraform state on Azure, and how to stand up resources in Azure using Terraform.

Labs

Lab 0 – Install and Configure Terraform

[Lab 1 - Azure Provider - Authenticating](https://labclient.labondemand.com/Instructions/245b57d8-53b3-4419-be46-dc0ab40f63bd#lab-01---azure-provider---authenticating)

[Lab 2 - Managing Terraform State on Azure](https://labclient.labondemand.com/Instructions/245b57d8-53b3-4419-be46-dc0ab40f63bd#lab-02---managing-terraform-state-on-azure) (Duration: 1 hour)

[Lab 3 - Create a Terraform Module](https://labclient.labondemand.com/Instructions/245b57d8-53b3-4419-be46-dc0ab40f63bd#lab-03---create-a-terraform-module) (Duration: 1 hour)

[Lab 4 - Deploying Resources](https://labclient.labondemand.com/Instructions/245b57d8-53b3-4419-be46-dc0ab40f63bd#lab-04---deploying-resources)

**Lab 0 - Install and Configure Terraform**

Download and Install Terraform for Windows

1.  Create the folder C:\\Program Files\\Terraform

2.  Open Terraform download page <https://www.terraform.io/downloads.html>

3.  Select 64-bit (386 version) and download the zip file (e.g.: terraform_1.9.8_windows_386) – **Latest version is 1.9.8** as of Nov 2024

4.  Open the folder where you saved the downloaded file, and unzip the package in the folder you created in the step 1 C:\\Program Files\\Terraform\\. Terraform runs as a single binary named **terraform.exe**

5.  Now we will make sure that the terraform binary is available on the PATH. **Open Control Panel** -\> **System** -\> **Advanced System settings** -\> **Environment Variables**

6.  In the **System Variables** panel, scroll down until you find **PATH**, then select **Path** and click **Edit**

7.  In the **Edit environment variable** window, click **New**

8.  Enter C:\\Program Files\\Terraform\\

9.  Click **OK** in all three windows closing the **System Properties** completely

**Validating Terraform installation**

After installing Terraform, verify that the installation worked, and what is the Terraform version.

1.  Open CMD

2.  Type terraform press **Enter**

3.  You will see the following result

![](3da1096cbd2d3efe4967daeea7fa5582.png)

4.  Now type terraform -version to validate Terraform installed version (As of Nov 2024, the latest version is 1.9.8. The version should be 1.9.8 or higher)

![A black and white text Description automatically generated](2142abb89b179b2424229d0686611e97.png)

4\. Install the Terraform Visual Studio Code extension

1.  Launch **Visual Studio Code**

2.  Open the **Extensions** view

    -   Windows/Linux: Ctrl+Shift+X

    -   macOS: Shift+⌘+X

![A screenshot of a computer Description automatically generated](e876b46ff55a9c67a4980c9fb888079c.png)

3.  Use the **Search Extensions** in Marketplace text box to search for the *Terraform* extension (pick HashiCorp Terraform)

4.  Select **Install** [Terraform](https://marketplace.visualstudio.com/items?itemName=mauve.terraform)

5\. Verify the Terraform extension is installed in Visual Studio Code

1.  Select **Extensions**

2.  Enter @installed in the search text box

![A screenshot of a computer Description automatically generated](03a90892e4d08464b1ad5e9c0541e6e4.png)

3.  The Terraform extension will appear in the list of installed extensions

4.  You can now run all supported Terraform commands in your Cloud Shell environment from within Visual Studio Code

**6. Module 7 - Lab 0 - Review**

In this LAB we completed the following activities

1.  Installation of prerequisites to run a Terraform template, by installing Azure CLI manually

2.  Download of Terraform, and system variables configuration to execute Terraform from Path in the local system

3.  Validation of Terraforms by checking the Terraform version

4.  Installation of Terraform extension for VS Code

5.  Validation of Terraform VS Code extension

**Lab 01 - Azure Provider - Authenticating**

Terraform supports a number of different methods for authenticating to Azure:

-   Authenticating to Azure using the Azure CLI (**we will be using this method**)

-   Authenticating to Azure using Managed Service Identity

-   Authenticating to Azure using a Service Principal and a Client Certificate

-   Authenticating to Azure using a Service Principal and a Client Secret (example covered in this guide)

Terraform recommends using either a Service Principal or Managed Service Identity when running Terraform non-interactively (such as when running Terraform in a CI server) - and authenticating using the Azure CLI when running Terraform locally.

**Setting up the Terraform provider**

In Terraform there are multiple [providers](https://www.terraform.io/docs/providers/index.html). A provider is responsible for understanding API interactions and exposing resources. Terraform basically adds an abstraction layer to json ARM templates which are the payloads that Azure's API interacts. You may create, manage, and update infrastructure for building resources such as physical machines, VMs, network switches, containers, and more.

In this lab, we will, of course, be using the [Azure provider](https://www.terraform.io/docs/providers/azurerm/index.html). The following Provider block can be specified. The Azure Provider version we will use in this lab will be 4.0.0

Prerequisites

1.  Navigate to the terraform_lab_dir where you will be writing code for your lab.

console

cd C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir

Service Principal

A Service Principal is an application within Azure Active Directory whose authentication tokens can be used as the client_id, client_secret, and tenant_id fields needed by Terraform (subscription_id can be independently recovered from your Azure account details).

It's possible to complete this task in either the Azure CLI or in the Azure Portal - For the purpose of this lab, we will simply authenticate with our user credentials. However, it is important to note that authenticating via a Service Principal with a client secret which has the minimum rights needed to the subscription is the standard authentication method for an automation pipeline.

**NOTE: You will need both CLI and Powershell versions for this lab.**

Install Azure CLI

1.  Navigate [here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) for installation instructions.

Login to azure Powershell Az

1.  Open a new Command Prompt session as an “Administrator” user. NOTE: Administrator privileges are necessary to perform the installation of modules below.

2.  Enter **Install-Module -Name Az**

3.  Enter **Import-Module -Name Az**

4.  Enter **Connect-AzAccount**

5.  Your default browser will pop up and prompt you for credentials. Select **Work/School** and input your credentials.

6.  Enter **Get-AzSubscription** and copy the id

7.  Enter **Set-AzContext -Subscription \<insert desired subscription id\>**

Login to azure Azure CLI

1.  Enter **az login**

2.  Your default browser will pop up and prompt you for credentials. Select **Work/School** and input your credentials.

3.  Once logged in, you will see a page like this. At this point you may navigate back to your already authenticated powershell session ![picture](5a0f8b1b33317a509c46eb4bb3efb8c8.png)

4.  Once logged in - it's possible to list the Subscriptions associated with the account via:

shell

**\$ az account list**

The output (similar to below) will display one or more Subscriptions - with the id field being the subscription_id field referenced above.

json

[

{

"cloudName": "AzureCloud",

"id": "00000000-0000-0000-0000-000000000000",

"isDefault": true,

"name": "PAYG Subscription",

"state": "Enabled",

"tenantId": "00000000-0000-0000-0000-000000000000",

"user": {

"name": "user@example.com",

"type": "user"

}

}

]

1.  Copy the subscription ID you will be using throughout this course.

2.  Enter **az account set --subscription \<insert desired subscription id\>**

3.  Congrats! You have successfully authenticated and set your subscription.

4.  However, for the purpose of this lab, replace the content in the file *C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir\\main.tf* with the content below. We also need the subscription ID in the provider block starting from version 4.0.0 as shown [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory). We will be setting the variable later in the next section and providing the subscription ID using a variable.

    terraform {

    required_providers {

    azurerm = {

    source = "hashicorp/azurerm"

    version = "4.0.0"

    }

    }

    }  
      
    provider "azurerm" {

    features {}

    subscription_id = var.azurerm_provider_subscription_id  
    }

When we run “terraform plan/apply” commands in the later section, Terraform will authenticate using the existing session that we established via azure cli.

Creating Terraform

1.  *Append* the code below to the same file, .\\main.tf

    data "azurerm_resource_group" "main" {

    name = var.rg_name

    }

Please note, *data* sources allow data to be fetched or computed for use elsewhere in Terraform configuration. Use of data sources allows a Terraform configuration to make use of information defined outside of Terraform, or defined by another separate Terraform configuration. The code above is fetching an existing resource of type [azurerm_resource_group](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html) which is a resource that comes from the azurerm provider. We have given it a local name "main" so that we may reference it in this fashion later, data.azurerm_resource_group.main. Please learn more [here](https://www.terraform.io/docs/configuration/data-sources.html)

2.  Also, *append* the code below to the same file, .\\main.tf

    resource "azurerm_public_ip" "vm" {

    name = "mypip"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    allocation_method = "Static"

    depends_on = [data.azurerm_resource_group.main]

    tags = {

    environment = "dev"

    }

    }

This will deploy a resource of type [azurerm_public_ip](https://www.terraform.io/docs/providers/azurerm/r/public_ip.html) which is a resource that comes from the azurerm provider. We have given it a local name "vm". Learn more on resource syntax [here](https://www.terraform.io/docs/configuration/resources.html). In addition, to learn more about the hcl configuration language, please review this [doc](https://www.terraform.io/docs/configuration/index.html)

Terraform Variables

In step 1 above and the previous section, you see that we are using this syntax, "var.rg_name" and var.azurerm_provider_subscription_id. We need to ensure that these variables and their values are constructed.

1.  Append the code below in the file .\\variables.tf

    variable "rg_name" {

    type = string

    description = "The name of the resource group"

    default = "XXXXX"

    }

    variable "azurerm_provider_subscription_id" {

    type = string

    description = "Subscription ID"

    default = "XXXXX"

    }

You will see that the variable default value is a dummy. We will construct a [tfvars](https://www.terraform.io/docs/configuration/variables.html#variable-definitions-tfvars-files) file which will be injected into this variables file via command line argument later on.

**NOTE:** we could have simply appended the above code to the same main.tf file that the provider object sits on. However, it is best practice to separate variables from code

Terraform tfvars

1.  Navigate to https://portal.azure.com

2.  In the left blade, click *Resource Groups*

3.  In the lab, there will be one Resource Group. *Copy* the name ![A screenshot of a computer Description automatically generated](4fc35d1730dfe3755eefccddb40d6f9f.png)

4.  Append the below code in the file .\\providers.tfvars and insert the value in "" copied from the previous step

    rg_name = "\<insert value\>"

5.  Append the below code in the file .\\providers.tfvars and insert the subscription ID value, which can be found from the Azure portal (under Subscriptions)

    azurerm_provider_subscription_id = "\<insert subscription ID here\>"

Terraform Outputs

1.  Let's ensure we output the main object upon deploying. Later, you will run a command that will output this variable. Ensure the below code exists in .\\outputs.tf

    output "rg_main_output" {

    value = "\${data.azurerm_resource_group.main}"

    }

The above code will output the rg_main_output object which has a value of data.azurerm_resource_group.main, the local object you instantiated at the step above.

1.  Also append the below code to, .\\outputs.tf

    output "vmEndpoint" {

    value = azurerm_public_ip.vm

    }

The above code will output the value created by the step above.

1.  Save all changes (File \> Save All)

Running Terraform (**Don’t run these commands yet!)**

When using Terraform, there are 3 basic commands that you must know

-   [terraform init](https://www.terraform.io/docs/commands/init.html) - to initialize the working directory

-   [terraform plan](https://www.terraform.io/docs/commands/plan.html) - to create a plan

-   [terraform apply](https://www.terraform.io/docs/commands/apply.html) - to apply the plan

**Lab Continued**

1.  Let's access the terraform init, plan, and apply methods. Run terraform init --help and skim through the capabilities. Feel free to ask questions during this time.

2.  Run **terraform plan --help**

3.  Run **terraform apply --help**

4.  Run **terraform init**

**NOTE:** every time we introduce a new module, we must run Terraform init. [Terraform init](https://www.terraform.io/docs/commands/init.html) is used to initialize a working directory containing terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

You should receive something similar to the below output

![A screenshot of a computer program Description automatically generated](ce5b92c68611dc0677726272d4887f5b.png)

1.  As a result of the last step, you will see a .terraform folder was automatically created in your working directory. Terraform's *init* managed a few things such as:

    1.  Backend Initialization (which we will cover in a later lab)

    2.  Child Module Installation

    3.  Plugin Installation

For more detail on Terraform init, please visit [here](https://www.terraform.io/docs/commands/init.html)

1.  Inject the *providers.tfvars* file and run terraform plan  
      
    **terraform plan -var-file="providers.tfvars"**

    Note: "terraform plan” is an intermittent step to run before actually deploying your resources. This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state.

2.  Run terraform apply and **enter yes** when prompted to perform the actions described in the output.  
      
    **terraform apply -var-file="providers.tfvars"**

Note: [terraform apply](https://www.terraform.io/docs/commands/apply.html) is the command that actually deploys your resources. This command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.

1.  Run **ls**. This will show the contents of the current working directory.

![A screenshot of a computer program Description automatically generated](8e912130f2ebcaeb1f778f5011220185.png)

You will see that a new file was created after you ran terraform apply. This .tfstate file is needed for Terraform to keep track of the state of your target infrastructure. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. If your .terraform folder uses a local backend to keep track of .tfstate, this state file will be updated upon each new terraform apply. This [state](https://www.terraform.io/docs/state/) is stored by default in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment. We will cover state more in depth in a separate lab.

1.  Run terraform plan again but with the “-out” parameter now, which will save the output to a file named myplan.  
      
    **terraform plan -var-file="providers.tfvars" -out myplan**

You will see that there are no changes to apply since the code has already been applied to the target resources.

1.  Run terraform apply again. (Because you used the -out argument, your plan was saved to *myplan*. Simply, you do not have to re-inject the tfvars files like you did for step 6 above). You will see that no changes will be made, and it was quite pointless to run an apply after seeing the plan had 0 changes in the previous step.

    **terraform apply myplan**

2.  Navigate to your subscription in the Azure Portal at <https://portal.azure.com> and click Resource Groups in the left blade.

![A screenshot of a computer Description automatically generated](83526d0b82d3aa44a0415b72502c3b9d.png)

1.  Click on the Resource Group named and you will see that Terraform did indeed create a public ip to an existing Resource Group by authenticating through the existing azure cli session.

2.  Congrats! You finished the lab that will allow you to deploy resources using Terraform through azure cli. From this point, you are able to create Azure Resources in the existing resource group using Terraform.

**Lab-02 - Managing Terraform State on Azure**

Terraform state is used to reconcile deployed resources with Terraform configurations. Using state, Terraform knows what Azure resources to add, update, or delete. By default, Terraform state is stored locally when running *Terraform apply*. This configuration is not ideal for a few reasons:

-   Local state does not work well in a team or collaborative environment

-   Terraform state can include sensitive information

-   Storing state locally increases the chance of inadvertent deletion

Centralizing your state file is a solution. In this lab, we will be doing just that. A common solution is to place your state file in an Azure Blob Storage Account that is locked down to the bare minimum. It is important to lock this down because Terraform prints out your state as is. This may include sensitive resource data like passwords. Also, please note that terraform supports state locking and consistency checking via native capabilities of Azure Blob Storage. This ensures there are no conflicts if multiple processes to terraform apply were to run.

**Create the Storage Account and store the access key in key vault**

Before using Azure Storage as a backend, a storage account must be created. The storage account can be created with the Azure portal, PowerShell, the Azure CLI, or Terraform itself. In this lab, we will deploy through the Azure CLI.

In this lab, there is a helper script that will

-   create a storage account named *terraformstate* followed by a random string

-   create a container in the account named *terraformstate* (Note: we can create different containers to host terraform states for different environments like production, stage, etc.)

-   create a key vault named *terraform-kv-* followed by the same random string as the storage account

-   set access policies to the key vault for the account associated to the email given as input and application id given as input

-   create a key vault secret with the name *ARM-ACCESS-KEY* and value of the storage account access key

-   stores information to be used throughout the lab in a file at terraform_lab_dir\\lab_output_logs\\remote_backend.log

Note: We can certainly place the storage account access key in a tfvars file as we did with the client secret in providers.tfvars. However, in this lab, we will show you a more secure option in which the secret only lives locally during the lifetime of your powershell session.

**Lab Steps:**

1.  Navigate to the terraform_lab_dir where you will be writing code for your lab.

[Launch the VS Code Terminal/Powershell session now and run the commands within the VS code]

**cd C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir**

1.  Replace the entire content of file in .\\helper_scripts\\set_remote_backend.ps1 with the content from the github file below

<https://github.com/sekar3s/Terraform-Lab/blob/main/set_remote_backend.ps1>

2.  [Login to azure (Azure CLI)](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-interactively)

3.  [Login to azure Powershell Az](https://learn.microsoft.com/en-us/powershell/azure/authenticate-interactive) (The script in the next step requires to run a mix of azure cli and azure powershell commands)

4.  In the terminal, **run** the script found at this location **.\\helper_scripts\\set_remote_backend.ps1** with the following parameters shown followed by parameters (remember to place double quotes) -adminEmail "\<insert the email account you use to login to the Azure subscription\>" -resource_group_name "\<Insert the name of the existing resource group. This value is assigned to rg_name in ./providers.tfvars\>". Below is an example of how this command will look like:

**.\\helper_scripts\\set_remote_backend.ps1 -adminEmail "joesmith@contoso.com" -resource_group_name "myrg"**

Select **[R] Run once** option. You should see output like the following

Checking for an active Azure login..............................................SUCCESS!

Creating Storage Account [terraformstate044330] and Container [terraformstate]...

SUCCESS!

Creating Terraform KeyVault: [terraform-kv-044330].............................SUCCESS!

Setting KeyVault Access Policy for Admin User: [joesmith@contoso.com]........SUCCESS!

Setting KeyVault Access Policy for Terraform SP with appid: [xxxx-4444-439a-lkj4-afa6f0983jrec]...SUCCESS!

Creating KeyVault Secret(s) for Terraform......................................SUCCESS!

Writing output to .\\lab_output_logs\\remote_backend.log

1.  When the script completes, it will have written information about the storage account and key vault in .\\lab_output_logs\\remote_backend.log so that you can reference the information throughout the lab. (Please disregard that the storage access_key value is stored in this file which defeats the whole purpose of the lab. It is simply there for easy referencing)

2.  Open the file .\\lab_output_logs\\remote_backend.log through vs code to see the contents

**Let's double check our work**

1.  Navigate to your subscription in the Azure Portal at [https://portal.azure.com](https://portal.azure.com/) and click Resource Groups in the left blade. Click on your Resource Group and see the resources deployed from this script.

2.  Navigate to the Azure Key Vault resource named terraform-kv-\* (where \* is a random string)

3.  Check that the Access Policies were configured by navigating to “Access policies” on the left pane. You should see one policy.

4.  Check that the secret was uploaded to Key Vault by clicking on Secrets under Objects

![A screenshot of a computer Description automatically generated](fd7c5cbe34a28e6845694d23b555d8c3.png)

1.  Click on ARM-ACCESS-KEY secret

2.  Click on the Current Version

3.  Click on Show Secret Value and see that the Azure Storage Access Key value has been uploaded

4.  Now, navigate to the newly provisioned storage account in the Resource Group

5.  Click on Containers under Data storage

![](aa7bb26df49d79ec6189def8ef0449dd.png)

1.  Click on terraformstate and see that it is a blank container. Later in the lab, this will be populated with a state file.

2.  Congrats! You created and configured the resources needed for setting up a remote backend for Azure and Terraform.

**Configure state backend with an access key**

The Terraform state backend is configured when running *Terraform init*. In this lab, we will be configuring the state backend using an Azure Storage Account access key. (Please note: there are a few other ways of configuring the backend that can be found [here](https://www.terraform.io/docs/backends/types/azurerm.html)). In order to configure the state backend, the following data is required.

-   storage_account_name - The name of the Azure Storage account.

-   container_name - The name of the blob container.

-   key - The name of the state store file to be created.

-   access_key - The storage access key.

You obtained this already from the previous section's step 5. Each of these values can be specified in the Terraform configuration file or on the command line, however it is recommended to use an environment variable for the access_key. Using an environment variable prevents the key from being written to disk.

**Steps:**

Code the backend resource

To configure Terraform to use the [backend](https://www.terraform.io/docs/backends/types/azurerm.html) resource type, include a *backend* configuration with a type of *azurerm* inside of the Terraform configuration. You will see in the backend [documentation](https://www.terraform.io/docs/backends/types/azurerm.html), that when authenticating using the Access Key associated with the Storage Account, you will need: *storage_account_name*, *container_name*, *key*, and access_key values to the configuration block.

**Lab Continued**

1.  Open the file .\\main.tf

2.  **Append** the below code in main.tf file within the terraform block after the *required_providers* block.

    backend "azurerm" {

    }

Notice how we are not instantiating the values here. When setting up terraform backend, you may, instead, pass them in during the terraform init phase with a tfvars file.

Set up backend.tfvars

1.  Go back to your powershell session on vscode

2.  Open the file.\\lab_output_logs\\remote_backend.log

3.  Copy the value assigned to storage_account_name

4.  Open the file .\\configs\\dev\\backend.tfvars

5.  Replace "" with value copied from step 3 above for the storage_account_name assignment

6.  Open the file .\\configs\\prod\\backend.tfvars

7.  Replace "" with value copied from step 3 above for the storage_account_name assignment. **We will use prod for a later lab**.

Notice how access_key is not being instantiated in this file. Instead, we will assign it to an environment variable and retrieve it from our Key Vault.

**Create environment variable**

1.  Open the file .\\lab_output_logs\\remote_backend.log

2.  Copy the value assigned to key_vault_name

3.  In the terminal, run the following code (make sure the value for --vault-name is correct). Also, include the \$ at the beginning of the command.

**\$env:ARM_ACCESS_KEY=\$(az keyvault secret show --name ARM-ACCESS-KEY --vault-name \<insert value from step 2\> --query value --output tsv)**

1.  Run the command to check out the value written to the variable.

**Write-Host \$env:ARM_ACCESS_KEY**

Note: Everytime, you open a new powershell session, you will have to retrieve from Azure Key Vault again.

Start Terraforming!

From the last lab, the below steps may be familiar to you. That is, terraform init, plan, and apply.

1.  First off, let's delete the current terraform.tfstate file. This will no longer be needed as it will be uploaded to our Blob container instead

**rm .\\terraform.tfstate**

terraform init - We will only initialize our dev environment during this time.

To inject both the backend.tfvars variables and the environment variable, we can run a [partial configuration](https://www.terraform.io/docs/backends/config.html#partial-configuration) in the command line with the -backend-config flag

1.  In the terminal, **run**

**terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

1.  Your terraform configuration should be successfully initialized by this step

terraform plan

1.  In the terminal, run

**terraform plan -var-file="providers.tfvars" -out myplan**

Note: [terraform plan](https://www.terraform.io/docs/commands/plan.html) is an intermittent step to run before actually deploying your resources. This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state.

terraform apply

1.  In the terminal, run apply and enter yes when prompted to perform the actions described in the output.

**terraform apply myplan  
  
Note1**: The apply in this step will fail since we created the public IP resource already in the previous lab and the information was stored in the local state file, which the remote backend file is not aware of. You can ignore this error for now, as we will be using a different resource name in the later labs.

**Note2**: [terraform apply](https://www.terraform.io/docs/commands/apply.html) is the command that actually deploys your resources. This command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.

1.  Run **ls**. You will see that a .tfstate file was not created here like last time. Instead, it was updated in your Blob container.

2.  Navigate to your subscription in the Azure Portal at <https://portal.azure.com> and click Resource Groups in the left blade.

3.  Now, navigate to the storage account.

4.  Click on Containers under Data Storage. Select the terraformstate container and you see that the dev.terraform.tfstate state file has been created

![](9fedabca1c5f9ded4b326fb003b98590.png)

8\. Congrats! You have just learned to secure Azure provisioning with Terraform backend and Azure Key Vault

A couple of things to note:

**State locking**

When using an Azure Storage Blob for state storage, the blob is automatically locked before any operation that writes state. This configuration prevents multiple concurrent state operations, which can cause corruption. For more information, see [State Locking](https://www.terraform.io/docs/state/locking.html) on the Terraform documentation. The lock can be seen when examining the blob though the Azure portal or other Azure management tooling. NOTE: The lock status is only visible when terraform

![A screenshot of a computer Description automatically generated](375856c883f0be29155ddc536a6d77d5.png)

Encryption at rest

By default, data stored in an Azure Blob is encrypted before being persisted to the storage infrastructure. When Terraform needs state, it is retrieved from the backend and stored in memory on your development system. In this configuration, state is secured in Azure Storage and not written to your local disk.

For more information on Azure Storage encryption, see [Azure Storage Service Encryption for data at rest](https://docs.microsoft.com/en-us/azure/storage/common/storage-service-encryption).

Learn more about Terraform backend configuration at the [Terraform backend documentation](https://www.terraform.io/docs/backends/).

**Lab-03 - Create a Terraform Module**

What is a Module

A module is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects. The *.tf* files in your working directory when you run terraform plan or terraform apply together form the root module. That module may call other modules and connect them together by passing output values from one to input values of another.

An example use case for creating a module is a frontend and backend scenario. You may find it logical to make one module for your frontend, and one for your backend. Because you can create modules within modules, you may also find it logical to place both modules within a parent module that encompasses the whole solution. Please use this [doc](https://www.terraform.io/docs/modules/index.html#when-to-write-a-module) as guidance for understanding *when to write a module*. Because your terraform code is abstracted into modules, you can create releases specific to your dev, stage, and production environments by simply inputting a different *.tfvars* file respective to each stage in your release pipeline.

**Lab**

In this lab, we will be following the *Standard Module Structure* as described in the official Terraform docs [here](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

During this exercise, we will place the public ip code that we have been creating throughout section 1 and 2 in a module called *my-frontend-module* (Please note: Simply placing a public ip in a module is not a good use case. These steps are built to simply walk through the standard module structure).

**DIY (Do it Yourself) Challenge (Estimated time of completion 1 hr)**

In this exercise, you will create your own module named *my-frontend-module* by referencing the [Standard Module Structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure). If you get stuck, feel free to peek through the VS Code *Explorer* pane at *C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir\\m07-s03-e01-frontend-module*. You will see that the *m07-s03-e01-frontend-module* directory, has a *main.tf* file that simply mocks the *azurerm_public_ip* type of what is currently in the root main.tf found at *C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir\\main.tf*. Similarly, outputs.tf has a copy of the *output* type and variables.tf has the variables to inject to the *azurerm_public_ip* object.

**Please follow the below requirements:**

1.  You must deploy 2 azurerm_public_ip's (PIPs). First PIP should be named "dev-pip" with a tag "environment: dev". Second PIP should be named "prod-pip" with a tag "environment: prod". Both PIP names should NOT have WHITESPACE.

2.  You must use the *./configs/dev/m07-s03-e01-dev.tfvars* and *./configs/prod/m07-s03-e01-prod.tfvars* files WITHOUT editing the files. (Notice the whitespace on the environment variable)

3.  You must output the azurerm_public_ip object through the command line with the output variable name "frontend_module". Example output like so:

**Outputs:**

frontend_module = {

"vmEndpoint" = {

"allocation_method" = "Static"

"id" = "/subscriptions/XXXXX/resourceGroups/YYYY/providers/Microsoft.Network/publicIPAddresses/prod-pip"

"idle_timeout_in_minutes" = 4

"ip_address" = "X.X.X.X"

"ip_version" = "IPv4"

"location" = "westus/eastus"

"name" = "prod/dev-pip"

"public_ip_address_allocation" = "Static"

"resource_group_name" = "YYYY"

"sku" = "Basic"

"tags" = {

"environment" = "prod/dev"

}

"zones" = []

}

}

1.  Both PIPs must exist at the same time

2.  Use *./configs/prod/backend-prod.tfvars* when deploying *./configs/prod/m07-s03-e01-prod.tfvars* and *./configs/dev/backend-dev.tfvars* when deploying *./configs/dev/m07-s03-e01-dev.tfvars*. Please note that it’s a recommended practice to separate access from state files in lower environments from state files in higher environments like production. It is especially important since state files contain plain text (i.e. passwords) of the state of your target environment.

By the end of the challenge, you should have the following target components:

1.  Two state files in your Azure Storage Account like so:  
      
    ![A screenshot of a computer Description automatically generated](efb6a94686ff153f5458ec265484c2d4.png)

2.  Two resource groups in your Subscription like so:  
    ![A screenshot of a computer Description automatically generated](9f8ee5cd3f8977ba282733769ac26ee3.png)

    ![A screenshot of a computer Description automatically generated](26c0c37611452a57f9096b11f8e9a24a.png)

Note: If you need hints throughout this DIY challenge, feel free to check out the section below. Feel free to collaborate with your peers and ask your instructor for guidance throughout this challenge. You will probably stumble upon at least one roadblock along the way, but that's okay! We are all here to learn!

**Extra Guidance and hints (if needed)**

Hints:

1.  Terraform has built-in [functions](https://www.terraform.io/docs/configuration/functions.html) that include string manipulation.

2.  You are creating a new module (rinse and repeat!). Don't forget what you learned in Lab 2! The backend state needs to be initialized when creating new modules.

3.  Remember where your configuration values for the azurerm provider exist. Don't forget what you learned in Lab 1 when running *terraform plan* and *terraform apply*

4.  For requirement 3, checkout [this](https://www.terraform.io/docs/configuration/outputs.html#accessing-child-module-outputs)

5.  During this session, Terraform will eventually ask you, "Do you want to copy existing state to the new backend?" Do you…? In other words, do you want to copy your dev state into your prod state? What would happen to the first public ip you created if you were to say "yes" and apply that change?

6.  Feel free to peek at *./m07-s03-e01-frontend-module* or the full solution flow section below if you get stuck

**Full Solution Flow (for a recap or extra guidance):**

You may have followed these steps (in a different order):

1.  Created a folder *C:\\Lab_Files\\M07_Terraform\\terraform_lab_dir\\my-frontend-module*

2.  Created a file README.md with your choice of text

3.  Created a *main.tf* file and copied the root *main.tf* file's *azurerm_public_ip* resource object

    resource "azurerm_public_ip" "vm" {

    name = "mypip""

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    allocation_method = "Static"

    tags = {

    environment = "dev"

    }

    }

1.  Realized the first requirement and edited this code to be more dynamic and look something like:

    resource "azurerm_public_ip" "vm" {

    name = "\${var.environment}-pip"

    location = var.location

    resource_group_name = var.rg_name

    allocation_method = "Static"

    tags = {

    environment = var.environment

    }

    }

1.  Looked at the *./configs/dev/m07-s03-e01-dev.tfvars* and *./configs/prod/m07-s03-e01-prod.tfvars* files and saw all the whitespace in the environment variable. You then realized the 2nd requirement. You took a look at the Terraform functions documentation and found this little gem, the [trimspace](https://www.terraform.io/docs/configuration/functions/trimspace.html) function. You then wrote something like this:

    resource "azurerm_public_ip" "vm" {

    name = "\${trimspace(var.environment)}-pip"

    location = var.location

    resource_group_name = var.rg_name

    allocation_method = "Static"

    tags = {

    environment = "\${trimspace(var.environment)}"

    }

    }

1.  You might've even done some research into how to not rewrite the trimspace logic by using [locals](https://www.terraform.io/docs/configuration/locals.html) like so:

    locals {

    environment = trimspace(var.environment)

    }

    resource "azurerm_public_ip" "vm" {

    name = "\${local.environment}-pip"

    location = var.location

    resource_group_name = var.rg_name

    allocation_method = "Static"

    tags = {

    environment = local.environment

    }

    }

1.  Because you just created the variables *environment*, *location*, *rg_name* and did not instantiate them anywhere, you created *./my-frontend-module/variables.tf* file with code like so:

variable "location" {

type = string

description = "The location of the resource group"

default = "eastus"

}

variable "environment" {

type = string

description = "The release stage of the environment"

default = "dev"

}

variable "rg_name" {

type = string

description = "The release stage of the environment"

default = "XXXXX"

}

1.  Realized that we still need to call this module from the root *main.tf* file and edited it like so (learn [here](https://www.terraform.io/docs/configuration/syntax.html#comments) about comments):

    terraform {

    required_providers {

    azurerm = {

    source = "hashicorp/azurerm"

    version = "4.0.0"

    }

    }

    backend "azurerm" {

    }

    }

    provider "azurerm" {

    features {}

    subscription_id = var.azurerm_provider_subscription_id

    }

    data "azurerm_resource_group" "main" {

    name = var.rg_name

    }

    \# resource "azurerm_public_ip" "vm" {

    \# name = "mypip"

    \# location = data.azurerm_resource_group.main.location

    \# resource_group_name = data.azurerm_resource_group.main.name

    \# allocation_method = "Static"

    \# depends_on = [data.azurerm_resource_group.main]

    \#

    \# tags = {

    \# environment = "dev"

    \# }

    \#}

    module "my_frontend_module" {

    source = "./my-frontend-module"

    location = var.location

    environment = var.environment

    rg_name = data.azurerm_resource_group.main.name

    }

2.  

1.  Realized that var.location and var.environment do not exist at the root level and added it to the existing root *./variables.tf* file like so:

    variable "rg_name" {

    type = string

    description = "The name of the resource group"

    default = "XXXXX"

    }

    variable "azurerm_provider_subscription_id" {

    type = string

    description = "Subscription ID"

    default = "XXXXX"

    }

    variable "location" {

    type = string

    description = "The location of the resource group"

    default = "eastus"

    }

    variable "environment" {

    type = string

    description = "The release stage of the environment"

    default = "dev"

    }

1.  Saw the 3rd requirement and realized that we already did something similar to that in the root folder's *outputs.tf*. Realized that the public ip object is now coded in a module. Said to yourself, "We first need to output the azurerm_public_ip object from the module. Then, output it from the root."

2.  You then created a *.\\terraform_lab_dir\\my-frontend-module\\outputs.tf* file in the module that looks exactly how the original root outputs.tf file looks like

    output "vmEndpoint" {

    value = azurerm_public_ip.vm

    }

1.  You searched the internet for how to access child module outputs and found [this](https://www.terraform.io/docs/configuration/outputs.html#accessing-child-module-outputs). At the root *outputs.tf* file you coded:

    output "frontend_module" {

    value = "\${module.my_frontend_module}"

    }

1.  You might have ran…

terraform plan -var-file="configs/dev/m07-s03-e01-dev.tfvars" -var-file="providers.tfvars" -out devplan

1.  …before running the init. You received the below error message if so:

![](4c4d45e47667a132499f79b0d7e4069b.png)

1.  Because you created a new module and remembered this concept from lab 2's *setting the remote backend*, you realized that you first had to run:

**terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

1.  You reran

**terraform plan -var-file="configs/dev/m07-s03-e01-dev.tfvars" -var-file="providers.tfvars" -out devplan**

1.  You ran …

**terraform apply devplan**

1.  … which outputs

    Outputs:

    frontend_module = {

    "vmEndpoint" = {

    "allocation_method" = "Static"

    "ddos_protection_mode" = "VirtualNetworkInherited"

    "ddos_protection_plan_id" = tostring(null)

    "domain_name_label" = tostring(null)

    "edge_zone" = ""

    "fqdn" = tostring(null)

    "id" = "/subscriptions/XXXXXXXX/Terraform-Basic/providers/Microsoft.Network/publicIPAddresses/dev-pip"

    "idle_timeout_in_minutes" = 4

    "ip_address" = "13.0.0.1"

    "ip_tags" = tomap(null) /\* of string \*/

    "ip_version" = "IPv4"

    "location" = "westus"

    "name" = "dev-pip"

    "public_ip_prefix_id" = tostring(null)

    "resource_group_name" = "Terraform-Basic"

    "reverse_fqdn" = tostring(null)

    "sku" = "Standard"

    "sku_tier" = "Regional"

    "tags" = tomap({

    "environment" = "dev"

    })

    "timeouts" = null /\* object \*/

    "zones" = toset(null) /\* of string \*/

    }

    }

1.  You patted yourself on the back! Great job! You then set on a mission to deploy to production.

2.  You flawlessly remember to run terraform init first:

    **terraform init -backend-config="configs/prod/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

3.  You are prompted with similar errors as below

![](2d4605191a67f0621d4f19e6a4cdff9a.png)

1.  You realized that terraform has detected a state change in the backend configuration due to the different file name, so you decide to run terraform init with -reconfigure option.

    **terraform init -reconfigure -backend-config="configs/prod/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

2.  The initialization is successful now and you see these state files created in your Azure Storage account.

![A screenshot of a computer Description automatically generated](efb6a94686ff153f5458ec265484c2d4.png)

1.  You ran

    **terraform plan -var-file="configs/prod/m07-s03-e01-prod.tfvars" -var-file="providers.tfvars" -out prodplan**

2.  You ran …

    **terraform apply prodplan**

3.  … which outputs

Outputs:

frontend_module = {

"vmEndpoint" = {

"allocation_method" = "Static"

"ddos_protection_mode" = "VirtualNetworkInherited"

"ddos_protection_plan_id" = tostring(null)

"domain_name_label" = tostring(null)

"edge_zone" = ""

"fqdn" = tostring(null)

"id" = "/subscriptions/XXXXXX/resourceGroups/Terraform-Basic/providers/Microsoft.Network/publicIPAddresses/prod-pip"

"idle_timeout_in_minutes" = 4

"ip_address" = "14.0.0.1"

"ip_tags" = tomap(null) /\* of string \*/

"ip_version" = "IPv4"

"location" = "westus"

"name" = "prod-pip"

"public_ip_prefix_id" = tostring(null)

"resource_group_name" = "Terraform-Basic"

"reverse_fqdn" = tostring(null)

"sku" = "Standard"

"sku_tier" = "Regional"

"tags" = tomap({

"environment" = "prod"

})

"timeouts" = null /\* object \*/

"zones" = toset(null) /\* of string \*/

}

}

1.  You patted yourself on the back! Great job!

**Clean up**

1.  Run terraform destroy to clean up your current prod environment. Enter **“yes”** to proceed with the cleanup.

**terraform destroy -var-file="providers.tfvars"**

1.  Now, reinitialize the dev environment using the -reconfigure option we used before when switching from dev to prod environment

**terraform init -reconfigure -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**  
  
**NOTE:** The reconfigure parameter is needed for terraform to reinitialize the dev environment

1.  Run terraform destroy -var-file="providers.tfvars" to destroy your current target architecture

    **terraform destroy -var-file="providers.tfvars"**

**Conclusion**

During this lab you:

1.  Created your own custom module.

2.  Managed using "separate" backend state mechanisms for different stages. This is meant to prepare you for deploying through a CI/CD pipeline.

3.  Learned about Terraform functions like trimspace.

4.  Learned how to output module objects.

Note: This lab exercise could have flowed more flawlessly if one were to use [terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) or [terraform env](https://www.terraform.io/docs/commands/env.html) which is deprecated. However, the current issue with using *terraform workspaces* is that *workspaces* are purposed to use one backend. As the documentation states

"Certain backends support multiple named workspaces, allowing multiple states to be associated with a single configuration. The configuration still has only one backend, but multiple distinct instances of that configuration to be deployed without configuring a new backend or changing authentication credentials."

In other words, one Storage Account with one access key would be used against the dev stage AND prod stage in our scenario. For the sake of this exercise, we could have simply ran:

1.  **terraform workspace new dev** (This would have created a state file in the Storage Account container and appended ":dev" to the name)

2.  **terraform workspace new prod** (This would have created a state file in the Storage Account container and appended ":prod" to the name)

Ultimately, you would end up with a default state file, a dev, and a prod one. However, with security in mind, you may want to consider making the access mechanisms specific to each environment.

Run **terraform workspace list** to find out what workspace you have been using for this lab

**Lab 04 - Deploying Resources**

In this lab, we will learn how to deploy Azure Resources using basic Terraform mechanics. We will learn how to use Terraform's [depends_on](https://www.terraform.io/docs/configuration/resources.html#depends_on-explicit-resource-dependencies) meta-argument, [provisioner](https://www.terraform.io/docs/provisioners/index.html) types, [data](https://www.terraform.io/docs/configuration/data-sources.html) sources all while securing our secrets in Key Vault.

**Prerequisites**

1.  We will create this environment in our *dev* environment. Run

**terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

1.  If you haven't run this from the last lab already, run **terraform destroy -var-file="providers.tfvars"** to destroy your target infrastructure generated from the last lab.

**Lab Continued (A)**

We will be writing this code at the main.tf root level. This code can definitely be placed in its own module later on - as you have learned from lab 3. For the purpose of this lab, please develop under the root directory module. If you get lost at any point, please retrace your steps or you may review <https://github.com/sekar3s/Terraform-Lab/blob/main/m07-s04-final-solution.tf> which is the full and final solution that contains all three files: outputs.tf, variables.tf, and main.tf code.

1.  Open *./main.tf*

2.  Delete everything except

    terraform {

    required_providers {

    azurerm = {

    source = "hashicorp/azurerm"

    version = "4.0.0"

    }

    }

    backend "azurerm" {

    }

    }

    provider "azurerm" {

    features {}

    subscription_id = var.azurerm_provider_subscription_id

    }

3.  Open *./outputs.tf*

4.  Delete everything. We will output different resources during this lab.

5.  Save all / CTRL\^S

**Lab Continued (B)**

1.  Open *./variables.tf*

2.  Ensure the below code exists

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    \# Environment Specs

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    variable "rg_name" {

    type = string

    description = "The name of the resource group"

    default = "XXXXX"

    }

    variable "azurerm_provider_subscription_id" {

    type = string

    description = "Subscription ID"

    default = "XXXXX"

    }

    variable "location" {

    type = string

    description = "The location of the resource group"

    default = "westus"

    }

    variable "environment" {

    type = string

    description = "The release stage of the environment"

    default = "dev"

    }

**Lab Continued (C)**

In this lab, we will need to reference our key vault created in lab 2. This Key Vault was not created by our Terraform code, rather the script found under *./helper_scripts/set_remote_backend.ps1*. We will learn how to interact with unmanaged Terraform resources during this lab like our Key Vault.

1.  Navigate to *./configs/dev/keyvault.tfvars* and insert the values shown in *./lab_output_logs/remote_backend.log (*don’t worry about *key_value_resource_id* parameter for now*)*

2.  Append the below lines to *./variables.tf*

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    \# Key Vault Components

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    variable "key_vault_name" {

    type = string

    description = "the name of the main key vault"

    default = "mykeyvault"

    }

    variable "key_vault_resource_id" {

    type = string

    description = "the resource id of the main key vault"

    default = "XXXXX"

    }

    variable "admin_pw_name" {

    type = string

    description = "the admin password of the vm"

    default = "admin-pw"

    }

**Lab Continued (D)**

In this lab we will create a simple Azure Ubuntu VM. The vm will have a NIC with a public ip. The vm will sit inside a subnet within a vnet. The subnet will have a network security group with one security rule allowing port 22 for ssh.

1.  Navigate to *./main.tf*

2.  Place the code we created in the last lab (from the module main.tf) in our root main.tf

    locals {

    environment = trimspace(var.environment)

    }

3.  Access the existing resource group like so:

    data "azurerm_resource_group" "main" {

    name = var.rg_name

    }

1.  Create your network security group which will allow for port 22.

    resource "azurerm_network_security_group" "nsg" {

    name = "nsg"

    location = "\${data.azurerm_resource_group.main.location}"

    resource_group_name = "\${data.azurerm_resource_group.main.name}"

    security_rule {

    name = "AllowSSHIn"

    priority = 1300

    direction = "Inbound"

    access = "Allow"

    protocol = "Tcp"

    source_port_range = "\*"

    destination_port_range = "22"

    source_address_prefix = "\*"

    destination_address_prefix = "\*"

    }

    tags = {

    environment = local.environment

    }

    depends_on = [data.azurerm_resource_group.main]

    }

Notice the depends_on meta-argument. The depends_on statement explicitly specifies a dependency. This is only necessary when a resource relies on some other resource's behavior, but does not access any of that resource's data in its arguments. Notice how this is not actually necessary as we are already accessing data.azurerm_resource_group.main arguments via *location* and *resource_group_name*. Nonetheless, it does not hurt to be explicit.

1.  Before we create a vm, we need to create the vnet that supports it. Paste the below vnet configuration. We will place the vm in subnet1. (For the purpose of the lab, we are hardcoding a couple values like the address_prefix. These values can be placed in variables later on)

    resource "azurerm_virtual_network" "main" {

    name = "\${local.environment}-network"

    address_space = ["10.0.0.0/16"]

    location = "\${data.azurerm_resource_group.main.location}"

    resource_group_name = "\${data.azurerm_resource_group.main.name}"

    subnet {

    name = "subnet1"

    address_prefix = "10.0.0.0/24"

    security_group = "\${azurerm_network_security_group.nsg.id}"

    }

    depends_on = [data.azurerm_resource_group.main, azurerm_network_security_group.nsg]

    }

2.  We need to create the NIC. Notice in the [documentation](https://www.terraform.io/docs/providers/azurerm/r/network_interface.html) that we need to obtain the subnet id as part of the ip configuration of the NIC. The subnet1 resource is contained within the *azurerm_virtual_network.main* resource. azurerm_virtual_network.main.subnet will print out as an array of map. Rather than having to extrapolate the subnet id from azurerm_virtual_network.main.subnet, we can simply use the [data](https://www.terraform.io/docs/configuration/data-sources.html) source for [subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html). We can do this by specifying the name, vnet name, and resource group name like so:

    data "azurerm_subnet" "subnet" {

    name = "subnet1"

    virtual_network_name = "\${local.environment}-network"

    resource_group_name = "\${data.azurerm_resource_group.main.name}"

    }

3.  Now, we can create our NIC and attach it to subnet1 like so:

    resource "azurerm_network_interface" "vm" {

    name = "\${local.environment}-nic"

    location = "\${data.azurerm_resource_group.main.location}"

    resource_group_name = "\${data.azurerm_resource_group.main.name}"

    ip_configuration {

    name = "ipconfig"

    subnet_id = data.azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = "\${azurerm_public_ip.vm.id}"

    }

    depends_on = [data.azurerm_resource_group.main, azurerm_virtual_network.main, azurerm_public_ip.vm]

    }

1.  Create the Public IP

    resource "azurerm_public_ip" "vm" {

    name = "mypip"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    allocation_method = "Static"

    depends_on = [data.azurerm_resource_group.main]

    }

1.  The ubuntu machine that we will be creating will use a simple password and username to logon to the machine. First we need to retrieve the existing Key Vault secret that was generated in lab 2 by the *./helper_scripts/set_remote_backend.ps1* script. Add the below to your main.tf file:

    data "azurerm_key_vault_secret" "main" {

    name = var.admin_pw_name

    key_vault_id = var.key_vault_resource_id

    }

1.  Lets create a locals argument for the vm configuration

    locals {

    vm = {

    computer_name = "vm1"

    user_name = "admin1234"

    }

    }

1.  Create the ubuntu machine

    resource "azurerm_virtual_machine" "vm" {

    name = "\${local.environment}-vm"

    location = "\${data.azurerm_resource_group.main.location}"

    resource_group_name = "\${data.azurerm_resource_group.main.name}"

    network_interface_ids = ["\${azurerm_network_interface.vm.id}"]

    vm_size = "Standard_DS1_v2"

    storage_image_reference {

    publisher = "Canonical"

    offer = "UbuntuServer"

    sku = "20.04-LTS"

    version = "latest"

    }

    storage_os_disk {

    name = "myosdisk1"

    caching = "ReadWrite"

    create_option = "FromImage"

    managed_disk_type = "Standard_LRS"

    }

    os_profile {

    computer_name = local.vm.computer_name

    admin_username = local.vm.user_name

    admin_password = data.azurerm_key_vault_secret.main.value

    }

    os_profile_linux_config {

    disable_password_authentication = false

    }

    tags = {

    environment = local.environment

    }

    depends_on = [data.azurerm_resource_group.main, azurerm_virtual_network.main]

    }

**Lab Continued (E)**

1.  Navigate to *./outputs.tf* and let's include our vm endpoint info

    output "vmEndpoint" {

    value = azurerm_public_ip.vm.ip_address

    }

    output "username" {

    value = local.vm.user_name

    }

    output "password" {

    value = data.azurerm_key_vault_secret.main.value

    }

**Lab Continued (F)**

1.  CTRL\^S to save main.tf, variables.tf, and outputs.tf in the root directory

2.  Run **terraform fmt**. [This](https://www.terraform.io/docs/commands/fmt.html) will format the spacing of your code.

3.  Go to <https://portal.azure.com>

4.  Navigate to the key vault under your resource group, click Properties under Settings, **copy** the resource id to be pasted during the next step

![A screenshot of a computer Description automatically generated](c9e11ab88cbc41b7c9325898e18186ea.png)

5.  Go to *./configs/dev/keyvaults.tfvars* and replace the value as advised in the current value for key_vault_name and key_vault_resource_id

\# To be filled in lab 4

key_vault_name="\<insert key_vault_name value from ..\\..\\lab_output_logs\\remote_backend.log\>"

key_vault_resource_id="\<insert key_vault_resource_id value from the previous step of Lab Continued (F)"

admin_pw_name="admin-pw"

**Checkpoint 1**

At this point you should have the following code complete:

1.  *./configs/dev/keyvaults.tfvars*

2.  *variables.tf* like so:

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    \# Environment Specs

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    variable "location" {

    type = string

    description = "The location of the resource group"

    default = "westus"

    }

    variable "environment" {

    type = string

    description = "The release stage of the environment"

    default = "dev"

    }

    variable "rg_name" {

    type = string

    description = "The name of the resource group"

    default = "XXXXX"

    }

    variable "azurerm_provider_subscription_id" {

    type = string

    description = "Subscription ID"

    default = "XXXXX"

    }

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    \# Key Vault Components

    \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

    variable "key_vault_name" {

    type = string

    description = "the name of the main key vault"

    default = "mykeyvault"

    }

    variable "key_vault_resource_id" {

    type = string

    description = "the resource id of the main key vault"

    default = "XXXXX"

    }

    variable "admin_pw_name" {

    type = string

    description = "the admin password of the vm"

    default = "admin-pw"

    }

1.  *./main.tf* like so:

    terraform {

    required_providers {

    azurerm = {

    source = "hashicorp/azurerm"

    version = "4.0.0"

    }

    }

    backend "azurerm" {

    }

    }

    provider "azurerm" {

    features {}

    subscription_id = var.azurerm_provider_subscription_id

    }

    locals {

    environment = trimspace(var.environment)

    }

    data "azurerm_resource_group" "main" {

    name = var.rg_name

    }

    resource "azurerm_network_security_group" "nsg" {

    name = "nsg"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    security_rule {

    name = "AllowSSHIn"

    priority = 1300

    direction = "Inbound"

    access = "Allow"

    protocol = "Tcp"

    source_port_range = "\*"

    destination_port_range = "22"

    source_address_prefix = "\*"

    destination_address_prefix = "\*"

    }

    tags = {

    environment = local.environment

    }

    depends_on = [data.azurerm_resource_group.main]

    }

    resource "azurerm_virtual_network" "main" {

    name = "\${local.environment}-network"

    address_space = ["10.0.0.0/16"]

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    }

    resource "azurerm_subnet" "subnet" {

    virtual_network_name = azurerm_virtual_network.main.name

    resource_group_name = data.azurerm_resource_group.main.name

    name = "subnet1"

    address_prefixes = ["10.0.0.0/24"]

    depends_on = [data.azurerm_resource_group.main, azurerm_network_security_group.nsg]

    }

    data "azurerm_subnet" "subnet" {

    name = "subnet1"

    virtual_network_name = "\${local.environment}-network"

    resource_group_name = data.azurerm_resource_group.main.name

    depends_on = [azurerm_virtual_network.main, azurerm_subnet.subnet]

    }

    resource "azurerm_subnet_network_security_group_association" "nsg-association" {

    subnet_id = azurerm_subnet.subnet.id

    network_security_group_id = azurerm_network_security_group.nsg.id

    }

    resource "azurerm_network_interface" "vm" {

    name = "\${local.environment}-nic"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    ip_configuration {

    name = "ipconfig"

    subnet_id = data.azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.vm.id

    }

    depends_on = [data.azurerm_resource_group.main, azurerm_virtual_network.main, azurerm_public_ip.vm]

    }

    resource "azurerm_public_ip" "vm" {

    name = "mypip"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    allocation_method = "Static"

    depends_on = [data.azurerm_resource_group.main]

    }

    data "azurerm_key_vault_secret" "main" {

    name = var.admin_pw_name

    key_vault_id = var.key_vault_resource_id

    }

    locals {

    vm = {

    computer_name = "vm1"

    user_name = "admin1234"

    }

    }

    resource "azurerm_linux_virtual_machine" "vm" {

    name = "\${local.environment}-vm"

    location = data.azurerm_resource_group.main.location

    resource_group_name = data.azurerm_resource_group.main.name

    network_interface_ids = ["\${azurerm_network_interface.vm.id}"]

    size = "Standard_DS1_v2"

    source_image_reference {

    publisher = "Canonical"

    offer = "0001-com-ubuntu-server-jammy"

    sku = "22_04-lts-gen2"

    version = "latest"

    }

    os_disk {

    name = "myosdisk1"

    caching = "ReadWrite"

    storage_account_type = "Premium_LRS"

    }

    computer_name = local.vm.computer_name

    admin_username = local.vm.user_name

    admin_password = data.azurerm_key_vault_secret.main.value

    disable_password_authentication = false

    tags = {

    environment = local.environment

    }

    depends_on = [data.azurerm_resource_group.main, azurerm_virtual_network.main]

    }

1.  *./outputs.tf* like so:

    output "vmEndpoint" {

    value = azurerm_public_ip.vm.ip_address

    }

    output "username" {

    value = local.vm.user_name

    }

    output "password" {

    value = nonsensitive(data.azurerm_key_vault_secret.main.value)

    }

**Lab Continued (G)**

Let's run it

1.  **terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

2.  **terraform plan -var-file="providers.tfvars" -var-file="configs/dev/keyvault.tfvars" -out myplan**

3.  **terraform apply myplan**

4.  Open a new powershell session by navigating to the terminal and clicking on the "+" icon. ![A black screen with a white arrow Description automatically generated](1bd19757b117bc40ad5b8a1d33f3ce8d.png)

5.  After you apply, you should see credentials for logging on. Run **ssh \<username value\>@\<vmEndpoint value\>**

6.  When prompted, enter yes

7.  Enter the password value, which can be found from the output of terraform apply

**Checkpoint 2**

At this point, we have created an azure vm. Let's run a quick demo on terraform [provisioner](https://www.terraform.io/docs/provisioners/index.html). Provisioners are used to execute scripts on a local or remote machine as part of resource creation or destruction. Provisioners can be used to bootstrap a resource, cleanup before destroy, run configuration management, etc. Let's run a script on our machine.

**Lab**

Create a file within the */terraform_lab_dir/*, called *test.sh* with the below content.

\#!/bin/bash

\# args=("\$@")

echo "Hello World"

\# echo -e "\\nhash -\> " \${args[0]}

\# echo -e \$(date)

\# echo -e "whoami -\> \$(whoami)"

We will copy this file to the machine by using using [file provisioner](https://www.terraform.io/docs/provisioners/file.html) and execute it via [azurerm_virtual_machine_extension](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html). The operations we want to execute on the machine are like so:

1.  chmod +x ./test.sh to make the script executable

2.  bash test.sh \>\> ./helloworld.log to execute the script and append the output to helloworld.log

The script will:

1.  print the date

2.  print "Hello World"

**Lab Continued (A)**

To copy a file to a machine and run it, we can do the following:

1.  Open *./main.tf*

2.  Use [null_resource](https://www.terraform.io/docs/providers/null/resource.html) which implements the standard resource lifecycle but takes no further action. It is basically a mechanism for running operations to supplement IaC without creating your standard resources like vms, vnets, vpcs.

    resource "null_resource" remoteExecProvisioner {

    }

1.  Let's create a local variable for the directory of the script. Add the below code:

    locals {

    scriptWorkingDir = "/home/\${local.vm.user_name}/"

    }

2.  To copy the file, let's use the [file provisioner](https://www.terraform.io/docs/provisioners/file.html). Within *file provisioner*, you provide a source, where your file exists, and destination, where to place the file on the remote machine once copied. Place this code inside the *null_resource.remoteExecProvisioner* brackets.

provisioner "file" {

source = "./test.sh"

destination = "\${local.scriptWorkingDir}/test.sh"

}

We also need to access the remote resource. We can simply ssh with the username and password by using the [connection provisioner](https://www.terraform.io/docs/provisioners/connection.html) like below. Place this code inside the *null_resource.remoteExecProvisioner* brackets.

connection {

host = azurerm_public_ip.vm.ip_address

type = "ssh"

user = local.vm.user_name

password = data.azurerm_key_vault_secret.main.value

agent = "false"

}

1.  We need to ensure the vm and the ssh port are set before attempting to copy the file. If we *plan* and *apply* at this point, you will most likely receive an error without the below code existing inside the *null_resource.remoteExecProvisioner* brackets.:

    depends_on = [azurerm_linux_virtual_machine.vm, azurerm_network_security_group.nsg]

At the end of Lab Continued (A) you should have added the below code to main.tf:

locals {

scriptWorkingDir = "/home/\${local.vm.user_name}/"

}

resource "null_resource" remoteExecProvisioner {

provisioner "file" {

source = "./test.sh"

destination = "\${local.scriptWorkingDir}/test.sh"

}

connection {

host = azurerm_public_ip.vm.ip_address

type = "ssh"

user = local.vm.user_name

password = data.azurerm_key_vault_secret.main.value

agent = "false"

}

depends_on = [azurerm_linux_virtual_machine.vm, azurerm_network_security_group.nsg]

}

**Lab Continued (B)**

Let's create the [custom script extension](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html) that will execute our bash script. Ensure *null_resource.remoteExecProvisioner* is referenced in the depends_on object.

1.  Open *./main.tf*

2.  Append the below code:

    resource "azurerm_virtual_machine_extension" "main" {

    virtual_machine_id = azurerm_linux_virtual_machine.vm.id

    name = "hostname"

    publisher = "Microsoft.Azure.Extensions"

    type = "CustomScript"

    type_handler_version = "2.0"

    settings = \<\<SETTINGS

    {

    "commandToExecute": "chmod +x \${local.scriptWorkingDir}/test.sh; sudo apt-get install dos2unix; dos2unix \${local.scriptWorkingDir}/test.sh; /bin/bash \${local.scriptWorkingDir}/test.sh \>\> \${local.scriptWorkingDir}/helloworld.log"

    }

    SETTINGS

    tags = {

    environment = local.environment

    }

    depends_on = [azurerm_linux_virtual_machine.vm, azurerm_network_security_group.nsg, null_resource.remoteExecProvisioner]

    }

The values placed in the commandToExecute object above are unix commands that will:

1.  Make the test.sh file executable

2.  Install [dos2unix](https://linux.die.net/man/1/dos2unix) command line tool to convert test.sh to a UNIX format.

3.  Convert the test.sh to UNIX format

4.  Run the script and append it to helloworld.log

**Lab Continued (C)**

At this point, you can:

1.  Save the changes (Go to File and click Save All)

2.  Return to the original terminal session by clicking on the carrot and selecting the 1st session. ![A screen shot of a computer Description automatically generated](391fc428de162e8c84da9a4983e144b1.png)

3.  **terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

4.  **terraform plan -var-file="providers.tfvars" -var-file="configs/dev/keyvault.tfvars" -out myplan**

5.  **terraform apply myplan**

6.  Go back to the the remote session. Run ssh \<username value\>@\<vmEndpoint value\> and password if needed

7.  Run **ls**

8.  You will see the files helloworld.log test.sh

9.  Run cat helloworld.log

10. You will see as output:

Hello World

\--------------------------------

**Checkpoint 3**

At this point we copied a file and ran it through a custom script extension. If we were to make incremental changes to our *./test.sh* script, our terraform code would actually not acknowledge that the file has changed. Terraform will see that test.sh is still the file to execute and will not see a difference.

**Lab Continued (A)**

Let's test this:

1.  Navigate to *./test.sh*

2.  Uncomment the below code

echo -e \$(date)

1.  Save your work (Go to File and click Save All)

2.  Return to the original terminal session by clicking on the carrot and selecting the 1st session. ![A screen shot of a computer Description automatically generated](391fc428de162e8c84da9a4983e144b1.png)

3.  **terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"**

4.  **terraform plan -var-file="providers.tfvars" -var-file="configs/dev/keyvault.tfvars" -out myplan**

5.  **terraform apply myplan**

6.  Go back to the the remote session. Run **ssh \<username value\>@\<vmEndpoint value\>** and password if needed

7.  Run **ls**

8.  You will see the files helloworld.log test.sh

9.  Run cat helloworld.log and you will not see a date (you will see the same as before)

10. Run cat test.sh and you will not see the uncommented code

**Lab Continued (B)**

Let's fix this. The way we can plan and apply incremental script changes is by the [triggers](https://www.terraform.io/docs/providers/null/resource.html#triggers) argument.

For Terraform to see that there is a difference in the file, we can do the below steps:

1.  Open *./main.tf*

2.  Let's generate and [archive](https://www.terraform.io/docs/providers/archive/d/archive_file.html) a zip file of test.sh so that later, we can take a hash of the zip file. Everytime the zip file hash changes, Terraform will know to trigger the script again.

    data "archive_file" "init" {

    type = "zip"

    source_file = "\${path.module}/test.sh"

    output_path = "\${path.module}/test.zip"

    }

Note: path.module is a built in terraform variable for finding the current working directory of your terraform root module.

1.  Within *null_resource.remoteExecProvisioner* brackets, place the below code which will grab the hash from data.archive_file.init:

    triggers = {

    src_hash = "\${data.archive_file.init.output_sha}"

    }

2.  Go to *./test.sh*

3.  Uncomment args=("\$@") and echo -e "\\nhash -\> " \${args[0]}

4.  Save the changes

5.  Navigate to *./main.tf*

6.  Under azurerm_virtual_machine_extension.main.settings, replace the "commandToExecute" value to include the argument like so and save the file:

    "commandToExecute": "chmod +x \${local.scriptWorkingDir}/test.sh; sudo apt-get install dos2unix; dos2unix \${local.scriptWorkingDir}/test.sh; /bin/bash \${local.scriptWorkingDir}/test.sh \${data.archive_file.init.output_sha} \>\> \${local.scriptWorkingDir}/helloworld.log"

7.  Return to the original terminal session by clicking on the carrot and selecting the 1st session. ![A screen shot of a computer Description automatically generated](391fc428de162e8c84da9a4983e144b1.png)

8.  **terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"** to intialize the archive_file provisioner

9.  **terraform plan -var-file="providers.tfvars" -var-file="configs/dev/keyvault.tfvars" -out myplan**

10. **terraform apply myplan**

11. Go back to the the remote session. Run **ssh \<username value\>@\<vmEndpoint value\>** and password if needed

12. Run **ls**

13. You will see the files helloworld.log test.sh

14. Run cat helloworld.log and you should see that this time it was successful in appending the output of test.sh with something similar to the below output:

Hello World

hash -\> 65d6812a83744bac8b16e09af2cf945b3c8539c8

Fri Sep 6 20:14:57 UTC 2019

Hello World

**Lab Continued (C)**

Terraform was able to see the difference because you ultimately changed the commandToExecute value. This is why we see the above output. Let's actually put this incremental change code to the test now.

1.  Navigate to *./test.sh*

2.  Uncomment echo -e "whoami -\> \$(whoami)"

3.  Save the work

4.  Return to the original terminal session by clicking on the carrot and selecting the 1st session. ![A screen shot of a computer Description automatically generated](391fc428de162e8c84da9a4983e144b1.png)

5.  **terraform init -backend-config="configs/dev/backend.tfvars" -backend-config="access_key=\$env:ARM_ACCESS_KEY"** to intialize the archive_file provisioner

6.  **terraform plan -var-file="providers.tfvars" -var-file="configs/dev/keyvault.tfvars" -out myplan**

7.  **terraform apply myplan**

8.  Go back to the the remote session. Run **ssh \<username value\>@\<vmEndpoint value\>** and password if needed

9.  Run **ls**

10. You will see the files helloworld.log test.sh

11. Run cat helloworld.log and you should see output of the whoami command

Note: You can run Powershell DSC through the custom script extension.

**Conclusion**

During this lab, you learned

1.  How to deploy multiple resources that depend on each other.

2.  How to manage resources that are not managed by Terraform

3.  How to provision a machine with incremental changes
