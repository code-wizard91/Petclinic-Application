#azure Provider

provider "azurerm" {

  version = "=2.0.0"

  features {}

}

resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}


resource "azurerm_log_analytics_workspace" "main" {
    name                = "${var.log_analytics_workspace_name}-k8-analytics01"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.k8s.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "main" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.main.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.main.id
    workspace_name        = azurerm_log_analytics_workspace.main.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "mizan"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name                = "agentpool"
        type                = "VirtualMachineScaleSets"
        enable_auto_scaling = True
        node_count          = var.agent_count
        max_count           = 3
        min_count           = 1
        vm_size             = "Standard_D2s_v3"
        

    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
        }
    }

    tags = {
        Environment = "Production"
    }
}


