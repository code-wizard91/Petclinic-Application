variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
    default = 1
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8-dns"
}

variable cluster_name {
    default = "k8-petclinic"
}

variable resource_group_name {
    default = "petclinic-k8s"
}

variable location {
    default = "east us"
}

variable log_analytics_workspace_name {
    default = "Petclinic-LogAnalyticsWorkspace"
}

variable log_analytics_workspace_location {
    default = "east us"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
