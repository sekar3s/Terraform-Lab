[CmdletBinding()]
param (

    # This is used to assign yourself access to KeyVault
    [Parameter(Mandatory=$true)]
    [String]$adminEmail = 'JohnSmith@contoso.com',
    [Parameter(Mandatory=$true)]
    [String]$resource_group_name = 'XXXXX'

)


$randomString= (New-Guid).Guid.substring(0,6)
$STORAGE_ACCOUNT_NAME="terraformstate$($randomString)"
$CONTAINER_NAME="terraformstate"
$KEY="<insert environment>.terraform.tfstate"
$LOCATION="eastus"
$STORAGE_SKU="Standard_LRS"

$admin_pw_name = "admin-pw"

$VAULT_NAME = "terraform-kv-$randomString"


#region Helper function for padded messages
function Write-HostPadded {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Message,

        [Parameter(Mandatory = $false)]
        [String]
        $ForegroundColor,

        [Parameter(Mandatory = $false)]
        [Int]
        $PadLength = 80,

        [Parameter(Mandatory = $false)]
        [Switch]
        $NoNewline
    )

    $writeHostParams = @{
        Object = $Message.PadRight($PadLength, '.')
    }
    if ($ForegroundColor) {
        $writeHostParams.Add('ForegroundColor', $ForegroundColor)
    }
    if ($NoNewline.IsPresent) {
        $writeHostParams.Add('NoNewline', $true)
    }
    Write-Host @writeHostParams
}
#endregion Helper function for padded messages


#region Check Azure login
Write-HostPadded -Message "Checking for an active Azure login..." -NoNewline
# Get current context
$azContext = Get-AzContext
if (-not $azContext) {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw "There is no active login for Azure. Please login first (eg 'Connect-AzAccount' and 'az login'"
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion Check Azure login


##################################################
#   set up storage account
##################################################

$taskMessage = "Creating Storage Account [$STORAGE_ACCOUNT_NAME] and Container [$CONTAINER_NAME]"
Write-HostPadded -Message "`n$taskMessage..."
try {
    # Create storage account
$storage = az storage account create --resource-group $resource_group_name --name $STORAGE_ACCOUNT_NAME --sku $STORAGE_SKU --encryption-services blob

# Get storage account key
$ACCOUNT_KEY=$(az storage account keys list --resource-group $resource_group_name --account-name $STORAGE_ACCOUNT_NAME --query [0].value --output tsv)

# Create blob container
$container = az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
} catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'


##################################################
#   end of set up storage account
##################################################

##################################################
#   set up key vault
##################################################

#region New KeyVault
$taskMessage = "Creating Terraform KeyVault: [$VAULT_NAME]"
Write-HostPadded -Message "`n$taskMessage..." -NoNewline
try {
    $azKeyVaultParams = @{
        VaultName         = $VAULT_NAME
        ResourceGroupName = $resource_group_name
        Location          = $LOCATION
        ErrorAction       = 'Stop'
        Verbose           = $VerbosePreference
        DisableRbacAuthorization = $true
    }
    $keyVaultObj = New-AzKeyVault @azKeyVaultParams | Out-String | Write-Verbose
} catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion New KeyVault


#region Set KeyVault Access Policy
$taskMessage = "Setting KeyVault Access Policy for Admin User: [$adminEmail]"
Write-HostPadded -Message "`n$taskMessage..." -NoNewline
$adminADUser = Get-AzADUser -UserPrincipalName $adminEmail
try {
    $azKeyVaultAccessPolicyParams = @{
        VaultName                 = $VAULT_NAME
        ResourceGroupName         = $resource_group_name
        ObjectId                  = $adminADUser.Id
        PermissionsToKeys         = @('Get', 'List')
        PermissionsToSecrets      = @('Get', 'List', 'Set', 'Delete')
        PermissionsToCertificates = @('Get', 'List')
        ErrorAction               = 'Stop'
        Verbose                   = $VerbosePreference
    }
    Set-AzKeyVaultAccessPolicy @azKeyVaultAccessPolicyParams | Out-String | Write-Verbose
} catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'

#region Terraform login variables

$terraformLoginVars = @{
    'ARM-ACCESS-KEY'      = $ACCOUNT_KEY
    $admin_pw_name        = "Pa$$w0rd123%"
}
#endregion Terraform login variables


#region Create KeyVault Secrets
$taskMessage = "Creating KeyVault Secret(s) for Terraform"
Write-HostPadded -Message "`n$taskMessage..." -NoNewline
try {
    foreach ($terraformLoginVar in $terraformLoginVars.GetEnumerator()) {
        $AzKeyVaultSecretParams = @{
            VaultName   = $VAULT_NAME
            Name        = $terraformLoginVar.Key
            SecretValue = (ConvertTo-SecureString -String $terraformLoginVar.Value -AsPlainText -Force)
            ErrorAction = 'Stop'
            Verbose     = $VerbosePreference
        }
        Set-AzKeyVaultSecret @AzKeyVaultSecretParams | Out-String | Write-Verbose
    }
} catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion Create KeyVault Secrets

##################################################
#   end of set up key vault
##################################################

Write-Host "Writing output to $PWD\lab_output_logs\remote_backend.log"

$labInfo = "##################################################`r`n"
$labInfo += "Key Vault information`r`n"
$labInfo += "-------------------------------------------------`r`n"
$labInfo += "key_vault_name=""$VAULT_NAME""`r`n`r`n"
$labInfo += "admin_pw_name=""$admin_pw_name""`r`n`r`n"



$labInfo += "##################################################`r`n"
$labInfo += "Storage Account information`r`n"
$labInfo += "-------------------------------------------------`r`n"
$labInfo += "resource_group_name= ""$resource_group_name""`r`n"
$labInfo += "storage_account_name= ""$STORAGE_ACCOUNT_NAME""`r`n"
$labInfo += "container_name= ""$CONTAINER_NAME""`r`n"
$labInfo += "key = ""$KEY""`r`n"
$labInfo += "access_key= ""$ACCOUNT_KEY""`r`n"

$labInfo | Out-File "$PWD\lab_output_logs\remote_backend.log"