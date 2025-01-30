locals {
  scriptWorkingDir = "/home/${local.vm.user_name}/"
}

resource "null_resource" remoteExecProvisioner {

provisioner "file" {
    source      = "./test.sh"
    destination = "${local.scriptWorkingDir}/test.sh"
  }

connection {
    host     = azurerm_public_ip.vm.ip_address
    type     = "ssh"
    user     = local.vm.user_name
    password = data.azurerm_key_vault_secret.main.value
    agent    = "false"
  }

  triggers = {
    src_hash = "${data.archive_file.init.output_sha}"
  }

  depends_on = [azurerm_linux_virtual_machine.vm, azurerm_network_security_group.nsg]
}

resource "azurerm_virtual_machine_extension" "main" {
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  name                 = "hostname"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
    "commandToExecute": "chmod +x ${local.scriptWorkingDir}/test.sh; sudo apt-get install dos2unix; dos2unix ${local.scriptWorkingDir}/test.sh; /bin/bash ${local.scriptWorkingDir}/test.sh >> ${local.scriptWorkingDir}/helloworld.log"
  }
  SETTINGS

  tags = {
    environment = local.environment
  }

  depends_on = [azurerm_linux_virtual_machine.vm, azurerm_network_security_group.nsg, null_resource.remoteExecProvisioner]
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/test.sh"
  output_path = "${path.module}/test.zip"
}