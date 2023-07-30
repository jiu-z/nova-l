variable "region" {
    description = "Deployment Region"
    type = string
}

variable "subnetwork_range" {
    description = "Subnet IP address space"
    type = string
}

variable "auto_create_subnetworks" {
    description = "Automatically create subnetworks"
    type = string
}

# Conditional variable for bastion host creation
variable "create_bastion" { 
    description = "When set to true, will create a bastion host GCE instance"
    default = false
    type = bool
}

variable "bastion_name" {
    description = "Name of bastion instance"
    type = string
}

variable "machine_type" {
    description = "GCP Instance Type"
    type = string
}

variable "zone" {
    description = "Deployment Zone"
    type = string
}

variable "image"{
    description = "Boot Disk Image"
    type = string
}

