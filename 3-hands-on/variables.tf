variable "auto_create_subnetworks" {
    description = "Automatically create subnetworks"
    type = string
}
variable "project_id" {
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
variable "service_name" {
    description = "service_name"
    type = string
}
variable "container_image" {
    description = "container_image"
    type = string
}
