# Resource Group
resource "azurerm_resource_group" "ml" {
  name     = "rg-aml-${var.prefix}${var.environment}"
  location = var.location
  tags     = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "ml" {
  name                = "acr1187${var.prefix}${var.environment}"    # This name needs to be globaly unique.
  resource_group_name = azurerm_resource_group.ml.name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true
  tags                = var.tags
}

# Application Insights
resource "azurerm_application_insights" "ml" {
  name                = "appi-${var.prefix}${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.ml.name
  application_type    = "web"
  tags                = var.tags
}

# Key Vault
resource "azurerm_key_vault" "ml" {
  name                = "kv-${var.prefix}${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.ml.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = var.tags
}

# Storage Account
resource "azurerm_storage_account" "ml" {
  name                     = "sa${var.prefix}${var.environment}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.ml.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Machine Learning Workspace
resource "azurerm_machine_learning_workspace" "ml" {
  name                    = "mlw-${var.prefix}${var.environment}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.ml.name
  storage_account_id      = azurerm_storage_account.ml.id
  application_insights_id = azurerm_application_insights.ml.id
  key_vault_id            = azurerm_key_vault.ml.id
  container_registry_id   = azurerm_container_registry.ml.id
  public_network_access_enabled = true
  sku_name                = "Basic"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

### AML compute instance
resource "azurerm_machine_learning_compute_instance" "ml" {
  name                          = "compute01-${var.prefix}${var.environment}"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.ml.id
  virtual_machine_size          = "STANDARD_DS11_v2"
  authorization_type            = "personal"
  node_public_ip_enabled        = true

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.uami.id,
    ]
  }
  description        = "Compute instance"

  assign_to_user {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
  }

  tags = var.tags
}
