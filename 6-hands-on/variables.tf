variable "project_id" {
    type = string
    default = "nova-cv"
}
variable "region" {
    type = string
    default = "us-central1"
}
variable "zone" {
    type = string
    default = "us-central1-a"
}
variable "service_name" {
    type = string
    default = "web"
}
variable "container_image" {
    type = string
    default = "us-central1-docker.pkg.dev/era-ax/infra/init:latest"
}
variable "policy_name" {
    type = string
    default = "web"
}
variable "certificate_name" {
    type = string
    default = "web"
}
variable "lb_name" {
    type = string
    default = "web"
}
