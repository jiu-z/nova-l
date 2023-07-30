### Introduction

Conditional expressions in Terraform follow the pattern of ternary  operators in popular programming languages. A ternary operator is made  up of three parts: a condition, a value if the condition evaluates to  true, and a value if the condition evaluates to false:

```
condition ? true_value : false_value
```

Conditional expressions can be used as a safeguard to ensure default  values are set for required attributes, but another effective use of  these expressions is to create cloud resources based on the needs of the infrastructure. When reusing Terraform configurations, there are some  cases where certain resources will not need to be provisioned. You will  see this decision-making in action in this lab.

In this lab, you will configure Terraform to create a bastion host  GCE instance based on the value of a boolean Terraform variable.

 

### Instructions

1. On the left side of the IDE below **PROJECT**, expand the **terraform-gcp** directory followed by the **modules** and **gce-bastion** directories:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid2-e9326a75-b60b-4394-95a4-19f436097c0a.png)

 

2. Double-click on the **gce-bastion/main.tf** file to review your module:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid0-7840e9f9-f6f7-41e4-a808-cad5df81efa4.png)

This module represents a Google Cloud Engine instance that will serve as a bastion host. A bastion host provides an external-facing entry  point for your cloud network.

In this lab scenario, you will configure a conditional expression  that will use this module to create a bastion host within a GCP network  if a specified variable is true. If the variable is false, the bastion  host will not be created.

The attributes of this `bastion` module will be set using variables that are declared in the **gce-bastion/variables.tf** file:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid1-82b9640b-3dd7-4819-b1a4-ff93726040e9.png)

Now that you're familiar with the module you'll be using, you will continue with configuring your main infrastructure.

 

3. Double-click on the **terraform-gcp/main.tf** file to open it in the editor, then paste in the following block:

```javascript

```

[Copy code](https://cloudacademy.com/lab/working-with-terraform-conditional-expressions-gcp/creating-terraform-resources-dynamically-with-conditional-expressions/?context_id=4773&context_resource=lp#)

```
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
provider "google" {
  credentials = "${file("../.sa_key")}"
  project = "cal-3030-a3bb33176e42"
  region = var.region
}
resource "google_compute_subnetwork" "ca-subnetwork" {
  name          = "ca-subnetwork"
  ip_cidr_range = var.subnetwork_range
  region        = var.region
  network       = google_compute_network.ca-network.id
}
resource "google_compute_network" "ca-network" {
  name                    = "ca-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}
module "bastion" {
    source       = "./modules/gce-bastion"
    name         = var.bastion_name
    machine_type = var.machine_type
    zone         = var.zone
    image        = var.image
    subnetwork   = google_compute_subnetwork.ca-subnetwork.id
}
```

In this configuration, two resource blocks are used to define the `ca-subnetwork` and `ca-network` resources. Similar to the bastion module, these resources will use variables to set values to their attributes. 

The `bastion` module is used at the bottom of the configuration. Each variable will be passed in using a **terraform.tfvars** file later in this lab step and the resolved ID of the `ca-subnetwork` resource will populate for the `subnetwork` attribute of your bastion module.

As the infrastructure currently stands, the `bastion` resource will be created by default. 

Before deploying this infrastructure, you will add a conditional  expression to the bastion module declaration which will determine  whether the resource is created or not.

 

4. In the `bastion` module block, add the following configuration:

```javascript

```

[Copy code](https://cloudacademy.com/lab/working-with-terraform-conditional-expressions-gcp/creating-terraform-resources-dynamically-with-conditional-expressions/?context_id=4773&context_resource=lp#)

```
1
    count        = var.create_bastion ? 1 : 0
```

The bastion resource configuration should now appear like the following:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid1-66a23a97-96f5-41a4-8b30-cf8dd799c3c1.png)

The `count` attribute is set to use the result of the conditional expression as the value.

The expression, `var.create_bastion ? 1 : 0,` can be read as:

- If the variable `create_bastion` is set to true, set the `count` value to `1`
- If the variable `create_bastion` is set to false, set the `count` value to `0`

By default, when a resource is defined in the Terraform configuration file, its count is set to 1. In Terraform, the count attribute is used  to determine how many of each resource must be created. So when the  count is set to 0, the resource will not be created. 

 

6. Double-click on the **terraform-gcp/terraform.tfvars** file to open it in the editor.

This file defines the values for all variables used in the Terraform project. This file is accompanied by a **variables.tf** file at the project level, which declares the variables to be used in the top-level **main.tf** configuration file.

 

7. Set the value of the `create_bastion` variable to *false*:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid3-ef21dc11-822f-428b-853a-7d2acc97fd17.png)

With the current conditional logic, the bastion host resource will not be created since this value is set to false.

 

8. In the terminal window, enter `cd terraform-gcp` to change into the `terraform-gcp` directory.

 

9. Enter the command `terraform init` in the terminal to initialize the directory to be used by Terraform:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-11-10%20at%205.52.47%20PM-bd4264fb-e3c2-46d6-adc1-43c312fd5a19.png)

 

10. Enter the command `terraform plan` in the terminal to preview the resources that will be deployed:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid4-89485c56-4312-4618-859b-43c715acfbd7.png)

The network and subnetwork resources are set to be created without the bastion host instance.

 

11. To validate the conditional expression further, return to the **terraform.tfvars** file, update the value of `create_bastion` to `true`:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid5-9cb91612-9e26-4a4c-87e7-d23fd36e2ede.png)

 

12. In the terminal window, enter `terraform plan` once more:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/blobid6-b5016cb2-8f3f-4019-8f35-beaec6716e21.png)

Three resources are set to deploy in this updated plan. With  the bastion host resource count dynamically set to 1, the module is now  used to plan for the creation of a single bastion host instance.

 

### Summary

In this lab, you configured Terraform to create a bastion host GCE instance based on the value of a boolean Terraform variable.