variable "name" {
    description = "GCP Instance Name"
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

variable "image" {
    description = "Boot Disk Image"
    type = string
}

variable "subnetwork" {
    description = "GCP Subnetwork Id"
    type = string
}
