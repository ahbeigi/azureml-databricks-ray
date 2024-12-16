# Resource Group
resource "azurerm_resource_group" "dbw" {
  name     = "rg-dbw-${var.prefix}${var.environment}"
  location = var.location
  tags     = var.tags
}

# Databricks worksapce
resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbw-${var.prefix}${var.environment}"
  resource_group_name = azurerm_resource_group.dbw.name
  location            = var.location
  sku                 = "premium"

  tags = var.tags
}

resource "databricks_service_principal" "dbw" {
  application_id        = azurerm_user_assigned_identity.uami.client_id
  display_name          = "UAMI service principal"
  allow_cluster_create  = true
  workspace_access      = true
  databricks_sql_access = true
}