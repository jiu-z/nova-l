Introduction

One of the main benefits of importing resources into a Terraform project is being able to modify the resource configuration using Terraform management tools. For example, a Google Cloud Storage bucket created in the GCP console can be imported into Terraform to be updated, reconfigured, or used by other resources in a project.

Additionally, when a resource is imported into a Terraform project, it becomes accessible as a local resource within a Terraform configuration file. This means that dynamic Terraform expressions can be used to access the resource instead of hard-coding its ID.

In this lab step, you will walk through the process of importing an existing Google Cloud Storage bucket into a Terraform project.
 
Instructions

1. To begin configuring your Terraform project, expand the terraform-gcp directory under PROJECT and double-click on main.tf:

alt

The empty file will open in the IDE editor.

 

2. Paste the following block into the main.tf file:

Copy code

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
  project = "cal-2933-94030766dca0"
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {}

The google_storage_bucket resource block has an identifier of file-store. This empty resource block is necessary for the next step in the importing process.

Regardless of the existing bucket's name or identifier, you are able to choose the identifier for this resource for use within your project. The empty resource configuration acts as a placeholder for the resource that is about to be imported.

 

3. In the terminal window, enter cd terraform-gcp to change into the terraform-gcp directory.

 

4. Enter the command terraform init in the terminal to initialize the directory to be used by Terraform:

alt

 

5. Enter the following command in the terminal to import the lab bucket into Terraform:

Copy code

terraform import google_storage_bucket.file-store calabs-bucket-1690684565

The terraform import command accepts a resource type followed by the local file-store identifier you specified previously. The command format matches the following:

terraform import {resource_type}.{identifier} {existing_resource_id}

The file_store identifier will be used to access the GCE bucket once it has been imported. The bucket ID references the GCE bucket created for you at the start of this lab.

You will see the following output upon a successful resource import:

alt

 

6. To retrieve the Terraform configuration of your imported resource, run the following command:

Copy code

1
terraform show

alt

The resulting output is the resource block definition for your file-store GCE bucket. The name property of this resource will match the GCE bucket ID used previously.

 

7. Copy the entire resource block and replace the existing, empty file-store definition in the main.tf file:

alt

 

8. In the terminal, enter terraform plan to validate the resource and identify configuration issues:

alt

The output will display three errors in the file_store resource configuration. When importing a resource into Terraform, you may encounter attributes that cannot be managed by Terraform. Simply removing the attributes in the resource block will resolve these issues.

 

9. In the file-store resource block, delete the self_link, url, and id attributes and their values.

Your resource block should now appear as the following:

alt

 

10. In the terminal, enter terraform plan once more to validate the configuration.

alt

The resulting output indicates your configuration in Terraform and the existing GCE bucket resource are now synced. At this point, you can modify the resource or utilize it within the Terraform infrastructure.

 

11. Paste in the following block at the bottom of your main.tf file:

Copy code

1
2
3
4
5
resource "google_storage_bucket_object" "file" {
  name   = "sample-file" 
  source = "files/one.txt"
  bucket = google_storage_bucket.file-store.name
}

The resource block above represents a single GCE object that you will be adding to the file-store bucket. The bucket attribute uses a Terraform expression to retrieve the name of the file-store bucket rather than hard-coding the identifier.

 

12. In the terminal, enter terraform apply followed by yes to create the object within the existing bucket:

alt

alt

The file object has been added to the existing GCE bucket successfully.
 
Summary

In this lab, you learned the process of importing an existing Google Cloud Storage bucket into a Terraform project.