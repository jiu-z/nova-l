### Introduction

One of the main benefits of importing resources into a Terraform  project is being able to modify the resource configuration using  Terraform management tools. For example, a Google Cloud Storage bucket  created in the GCP console can be imported into Terraform to be updated, reconfigured, or used by other resources in a project.

Additionally, when a resource is imported into a Terraform project,  it becomes accessible as a local resource within a Terraform  configuration file. This means that dynamic Terraform expressions can be used to access the resource instead of hard-coding its ID.

In this lab step, you will walk through the process of importing an  existing Google Cloud Storage bucket into a Terraform project.

###  

### Instructions

1. To begin configuring your Terraform project, expand the **terraform-gcp** directory under **PROJECT** and double-click on **main.tf**:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-11-10%20at%204.54.27%20PM-33a7cf13-0966-4059-8d48-818850a76b83.png)

The empty file will open in the IDE editor.

 

2. Paste the following block into the **main.tf** file:

```bash

```

[Copy code](https://cloudacademy.com/lab/importing-existing-infrastructure-into-terraform-gcp/importing-gcp-resources-into-terraform/?context_id=4773&context_resource=lp#)

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
  project = ""
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {}
```

The `google_storage_bucket` resource block has an identifier of `file-store`. This empty resource block is necessary for the next step in the importing process.

Regardless of the existing bucket's name or identifier, you are able  to choose the identifier for this resource for use within your project.  The empty resource configuration acts as a placeholder for the resource  that is about to be imported.

 

3. In the terminal window, enter `cd terraform-gcp` to change into the `terraform-gcp` directory.

 

4. Enter the command `terraform init` in the terminal to initialize the directory to be used by Terraform:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-11-10%20at%205.52.47%20PM-bd4264fb-e3c2-46d6-adc1-43c312fd5a19.png)

 

5. Enter the following command in the terminal to import the lab bucket into Terraform:

```

```

[Copy code](https://cloudacademy.com/lab/importing-existing-infrastructure-into-terraform-gcp/importing-gcp-resources-into-terraform/?context_id=4773&context_resource=lp#)

```
terraform import google_storage_bucket.file-store The lab bucket name will appear once the environment setup has completed
```

The `terraform import` command accepts a resource type followed by the local `file-store` identifier you specified previously. The command format matches the following:

terraform import *{resource_type}.{identifier} {existing_resource_id}*

The `file_store` identifier will be used to access the GCE bucket once it has been imported. The bucket ID references the GCE  bucket created for you at the start of this lab.

You will see the following output upon a successful resource import:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.50.21 AM-95a32079-3b77-407a-b81a-f86c00562459.png)

 

6. To retrieve the Terraform configuration of your imported resource, run the following command:

```javascript

```

[Copy code](https://cloudacademy.com/lab/importing-existing-infrastructure-into-terraform-gcp/importing-gcp-resources-into-terraform/?context_id=4773&context_resource=lp#)

```
1
terraform show
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.51.01 AM-61e62ca4-30d6-45d3-943f-138a52afd248.png)

The resulting output is the resource block definition for your `file-store` GCE bucket. The `name` property of this resource will match the GCE bucket ID used previously.

 

7. Copy the entire `resource` block and replace the existing, empty `file-store` definition in the **main.tf** file:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.51.47 AM-8072a6f1-c7cb-46d2-b022-5a614501e1f0.png)

 

8. In the terminal, enter `terraform plan` to validate the resource and identify configuration issues:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.52.36 AM-746e0270-eb2e-4377-9dad-d5e916d004e1.png)

The output will display three errors in the `file_store`  resource configuration. When importing a resource into Terraform, you  may encounter attributes that cannot be managed by Terraform. Simply  removing the attributes in the resource block will resolve these issues.

 

9. In the `file-store` resource block, delete the `self_link`, `url`, and `id` attributes and their values.

Your resource block should now appear as the following:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.53.53 AM-14a03276-3849-4331-9e30-adfceb2271cc.png)

 

10. In the terminal, enter `terraform plan` once more to validate the configuration.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.54.41 AM-ce27e97d-2d74-4748-b1d9-799830613326.png)

The resulting output indicates your configuration in Terraform and  the existing GCE bucket resource are now synced. At this point, you can  modify the resource or utilize it within the Terraform infrastructure.

 

11. Paste in the following block at the bottom of your **main.tf** file:

```bash

```

[Copy code](https://cloudacademy.com/lab/importing-existing-infrastructure-into-terraform-gcp/importing-gcp-resources-into-terraform/?context_id=4773&context_resource=lp#)

```
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
```

The resource block above represents a single GCE object that you will be adding to the `file-store` bucket. The `bucket` attribute uses a Terraform expression to retrieve the name of the `file-store` bucket rather than hard-coding the identifier.

 

12. In the terminal, enter `terraform apply` followed by *yes* to create the object within the existing bucket:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.56.43 AM-7d0a7a69-4af9-4166-9c5a-9f43c6a56538.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-17 at 8.58.25 AM-5302d2eb-3875-4073-8be2-3b918aa515e6.png)

The file object has been added to the existing GCE bucket successfully.

###  

### Summary

In this lab, you learned the process of importing an existing Google Cloud Storage bucket into a Terraform project.