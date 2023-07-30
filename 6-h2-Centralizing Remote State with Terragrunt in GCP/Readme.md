### Introduction

Terragrunt acts as a thin wrapper with additional tooling to aid in  the management of larger Terraform projects. To continue the common DRY  pattern to avoid redundancy, Terragrunt provides a centralized way to  manage remote state.

As a refresher, with remote state, Terraform is simply storing the  state data of your resources in a remote data store. In Google Cloud  Platform, this is commonly a Google Cloud Storage (GCS) bucket.

In this lab step, you will work with a Terraform project that  consists of multiple environments, and configure a GCS bucket as your  remote data store using Terragrunt.

 

### Instructions

1. Expand the **terragrunt-gcp** directory under **PROJECT** to begin reviewing your Terraform project:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20211230095207-1-cb9445b9-e4c6-4f0b-a1df-4aef6abe6061.png)

The project contains three directories and a root-level **terragrunt.hcl** file.

The **dev**, **prod**, and **qa** directories represent the three environments of this Terraform project and each contains the following files:

- The **main.tf** file is the standard Terraform  configuration file. This file contains the resource configurations to  deploy a Google Cloud Platform network and subnetwork.
- The directory-level **terragrunt.hcl** files in each environment will contain the specific configurations to sync it with the root-level **terragrunt.hcl** file. Each of these directory-level files can be referred to as a *child*.

The root-level **terragrunt.hcl** file acts as your project wrapper and can be referred to as the *parent*. As you will see later in this lab step, the child **terragrunt.hcl** files in each environment directory will have a specific pointer to this parent file. 

 

2. To configure the root-level **terragrunt.hcl** file, double-click on the file to open it in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20211230102148-2-2d2ece37-74b4-48ff-852d-9e64e5c65813.png)

 

3. Paste in the following code block to the **terragrunt.hcl** file:

```

```

[Copy code](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/managing-remote-state-with-terragrunt-in-gcp/?context_id=4773&context_resource=lp#)

```
# Remote state location for dev, prod, & qa child folders
remote_state {
  backend = "gcs"
 
  config = {
    bucket = "lab-bucket-cal-2831-87e766538bbd"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-2831-87e766538bbd"
    location = "us-central1"
  }
}
 
# Generate a Google provider block for each child folder
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
 
provider "google" {
  credentials = "/home/project/.sa_key"
  project = "cal-2831-87e766538bbd"
  region = "us-central1"
}
  EOF
}
```

There are two main blocks to consider in this file, `remote_state`, and `generate`. 

The `remote_state` block defines the Google Cloud Storage (GCS) configuration for each environment's backend. The config block defines the `bucket` and the appropriate `prefix` for each environment. The `bucket` prefix will organize the remote state files into separate folders named after the environment folders themselves. Once initialized and applied, the lab bucket will contain the following folders:

- `lab-bucket-xxxx/dev/`
- `lab-bucket-xxxx/prod/`
- `lab-bucket-xxxx/qa/`

Each folder will contain a separate **terraform.tfstate** file.

The `generate` block has the `provider` type specified, which means it will generate a provider configuration file for each of the environments. The `path` attribute indicates the file created will be named `provider.tf` and overwriting this file (if it exists) is allowed. 

The `content` attribute holds the specific `terraform` and `provider` blocks required to deploy the resources into each environment. These  are standard configurations for deploying GCP resources with Terraform,  like the project ID and service account credentials.

 

4. In the terminal, enter the following command to change into the **terragrunt-gcp** directory:

```

```

[Copy code](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/managing-remote-state-with-terragrunt-in-gcp/?context_id=4773&context_resource=lp#)

```
cd terragrunt-gcp
```

You will now initialize the remote backend for all three environments.

 

5. In the terminal, enter the following command and enter *y* at the prompt to initialize your remote backend:

```

```

[Copy code](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/managing-remote-state-with-terragrunt-in-gcp/?context_id=4773&context_resource=lp#)

```
terragrunt run-all init
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103153801-4-a4d3f77a-54e2-4954-9b6d-ed0e5cd928f5.png)

The prompt will ask if you'd like to create the remote state source  bucket since it currently does not exist. You may encounter three  prompts, but only one *y* to confirm is needed.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103161831-10-8f5ce226-57b2-4c2f-8205-faee4080a255.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103161834-11-71a7f41a-5506-4268-829c-e2166073cb0e.png)

***Note\***: There will be a pause after the successful initialization message for each environment. Simply press **enter** to continue initializing each environment. 

Each `terragrunt` command used in this lab step will utilize the `run-all` flag, which runs the subsequent command for all of the subdirectories below the root-level directory (**dev**, **prod**, and **qa**).

Now that the remote source bucket has been initialized, you will files that make up each environment directory.

 

6. To review the resources being deployed in each environment, double-click on the **dev/main.tf** and the **dev/terragrunt.hcl** files to open them in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20211230101915-1-9322af69-ff09-4776-8770-ae68b62a1021.png)

In **dev/****main.tf** you will notice the  following configurations. All three environments will deploy the same  type of GCP resources. The only differences are the resource identifiers and CIDR block ranges.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103154654-6-50735b4f-6173-41f2-bfaf-ed07c56c3e97.png)

Each environment will reference an empty object for the `gcs` backend. You've already defined the backend for all three environments in the root-level **terragrunt.hcl** file. 

A `google_compute_network` and a `google_compute_subnetwork` will be created, and each resource name and identifier is prefixed with the name of the folder. The `ip_cidr_range` of each subnetwork will also differ in each environment to ensure no addresses are overlapping.

In each environment's **terragrunt.hcl** file, you will find the following code:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103153543-1-4ab6f098-04cf-4a4e-837f-9b487c87efa5.png)

The `include` block connects this child folder to the main, root-level **terragrunt.hcl** file. Essentially, this file acts as a pointer to the root-level file of the  same name in order to inherit the configurations defined in the parent  file. This functionality is a major benefit of using Terragrunt since it provides developers with the ability to define their backend  configurations once and apply them to various environments or projects.

The use of Terraform modules could be included to further decrease  the number of configurations for each environment, but this topic is  outside the scope of this lab. Utilizing modules to organize resource  configurations will be covered in a separate lab.

 

7. Double-click on the **dev/****provider****.tf** file to open it in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103160036-8-f79f1563-310c-45c0-b88c-90f8ea5d9309.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103160102-9-2b6133bc-0e45-4816-8589-c9efbb41dd16.png)

This file is a result of the `generate` configuration block in the root-level **terragrunt.hcl** file and was created during the previous initialization step. It includes the `terraform` and `provider` blocks that enable each environment to deploy resources into the Google Cloud Platform. 

 

8. In the terminal, enter the following command and enter *y* at the prompt to deploy these resources to all three environments:

```

```

[Copy code](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/managing-remote-state-with-terragrunt-in-gcp/?context_id=4773&context_resource=lp#)

```
terragrunt run-all apply
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103153628-2-61c759c5-4e77-454f-8931-66cc9f0aa165.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103153651-3-f94f77d0-4303-4aa7-b99b-de387ca74188.png)

The order of resource creation will vary, but all three environments will deploy successfully with a total of 2 resources each. 

Now that your environments are deployed, you will verify the folder structure of the remote source bucket.

 

9. Enter the following **gsutil** command to list the contents of your remote backend bucket:

```

```

[Copy code](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/managing-remote-state-with-terragrunt-in-gcp/?context_id=4773&context_resource=lp#)

```
gsutil ls gs://lab-bucket-cal-2831-87e766538bbd/*
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220103154243-5-15211d42-f870-4d8d-a3ae-380e4ae3f0fe.png)

With this output, you can confirm that each environment has a separate folder with a **terraform.tfstate** file that holds the infrastructure's state.

 

### Summary

In this lab, you configured a Google Cloud Storage bucket as a centralized remote data store using Terragrunt.