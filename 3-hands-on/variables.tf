variable "auto_create_subnetworks" {
    description = "Automatically create subnetworks"
    type = string
}
variable "subnetwork_range" {
    description = "Subnet IP address space"
    type = string
}
variable "region" {
    description = "Deployment Region"
    type = string
}
variable "image"{
    description = "Boot Disk Image"
    type = string
}
variable "machine_type"{
    description = "GCP Instance Type"
    type = string
}
variable "zone" {
    description = "Deployment Zone"
    type = string
}
