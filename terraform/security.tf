# User-Assigned Managed Identity (UAMI)
resource "azurerm_user_assigned_identity" "uami" {
  name                = "uami-${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.ml.name
  location            = var.location
}
