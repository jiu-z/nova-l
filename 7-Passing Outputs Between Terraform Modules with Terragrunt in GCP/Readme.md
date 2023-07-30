### Introduction

A virtual private cloud, or cloud network, is much less likely to be  updated compared to individual cloud instances. For example, the  instances may require software updates or changes to capacity. Although  this type of resource may vary, it's crucial to understand how to  establish relationships between resources that are stable, and resources that will require frequent updates. With Terragrunt dependencies, you  can easily associate two separate types of resource modules within a  Terraform project.

In this lab step, you will use Terragrunt to establish a dependency  between a Google Cloud Network module, and a Google Cloud Engine  instance module. Once the dependency is established, you will learn how  to pass data between these separate modules. The example used in this  lab is straightforward by design to ensure that the typical flow of data can be illustrated.

 

### Instructions

1. Expand the **terragrunt-gcp** directory under **PROJECT** to begin reviewing your Terraform project:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220106194200-2-c591a5d3-7eba-46d1-b9f6-190754cfdecb.png)

 

2. Double-click the root-level **terragrunt-gcp/terragrunt.hcl** file to open it in the editor.

 

3. Paste the following code into **terragrunt-gcp/terragrunt.hcl**:

```

```

[Copy code](https://cloudacademy.com/lab/syncing-modules-with-outputs-using-terragrunt-gcp/passing-outputs-between-gcp-modules-with-terragrunt/?context_id=4773&context_resource=lp#)

```
remote_state {
  backend = "gcs"
 
  config = {
    bucket = "calabs-bucket-1690693208"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-3042-907234c379d9"
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
  backend "gcs" {}
}
provider "google" {
  credentials = "/home/project/.sa_key"
  project = "cal-3042-907234c379d9"
  region = "us-central1"
}
  EOF
}
```

A `remote_state` block is defined in order to a GCS bucket as the remote state source. Each module's remote state file will be  stored in a separate subfolder within this GCS bucket. This bucket has  been created on your behalf at the start of the lab. 

The `generate` block is responsible for creating the necessary `provider.tf` configuration file that each child module will access within this project. The `backend "gcs"` empty declaration references the remote state source being defined above.

 

4. Expand the **network** directory, and double-click on the **network/terragrunt.hcl** file:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220106194746-3-b02b6685-7077-4ca6-b132-f2c2136413b0.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.38.54 PM-46fd55c7-1e13-465c-8fda-fd6e5bb16dc8.png)

This is a standalone module that does not rely on others and will adopt the configurations in the root-level **terragrunt.hcl** file.

 

5. Double-click on **network/main.tf** and **network/outputs.tf** to open them in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.51.04 PM-9982f797-3520-4d07-b8c9-70b16ad12267.png)

The **main.tf** file in this directory holds the configurations for the `network` and `subnetwork` resources. These types of resources are seldom updated once they've  been initially set up. These resources can be split into two separate  modules, but have been grouped together for this lab for the sake of  simplicity.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.50.40 PM-ca0ffc52-0005-4ce2-9bac-be470dd4c7da.png)

The **outputs.tf** file in this directory contains the single output variable for the **network** module. You will follow this `subnetwork_id` variable throughout this lab step to gain an understanding of how  Terragrunt passes outputs to resources downstream. Remember, this must  first be applied in order for this output to render and be passed down.

Now you will review the GCE instance module that depends on the output of the network module.

 

6. Expand the **gce** directory and double-click on the **gce/main.tf** file:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220106200046-4-89f2b79c-9d38-4a68-91ed-411128286446.png)

This **main.tf** file should look familiar. It contains a single GCE instance definition. This file is where the `subnetwork_id` output variable passed down from the network module is utilized.

Declaring the `subnetwork_id` variable is done in the same manner as a normal Terraform project, by using a **variables.tf** file. The `subnetwork_id` variable declaration can be found in the **gce/variables.tf** file. The expected variables may be declared the same, but Terragrunt handles the passing of outputs a little differently. 

 

7. Double-click on the **gce/terragrunt.hcl** file to open it in the editor.

This file is currently empty.

 

8. Paste the following code into the **gce/terragrunt.hcl**:

```

```

[Copy code](https://cloudacademy.com/lab/syncing-modules-with-outputs-using-terragrunt-gcp/passing-outputs-between-gcp-modules-with-terragrunt/?context_id=4773&context_resource=lp#)

```
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
 
dependency "network" {
  config_path = find_in_parent_folders("network")
}
 
inputs = {
  subnetwork_id = dependency.network.outputs.subnetwork_id
}
```

Similar to the **network/terragrunt.hcl** file, the `include `block will adopt the configurations of the root-level **terragrunt.hcl** file. 

The `dependency `block is declared next with the `network` identifier. The `config_path` attribute of this block uses the built-in `find_in_parent_folders` helper to retrieve the `network` module. This is how you declare a dependency and access the output variables of separate modules in Terragrunt. 

Finally, the `inputs` object references the single expected input for the **gce** module, the `subnetwork_id` of the `network` module. 

Now that you've seen the path of your module outputs and how they're  accessed, you will now observe how Terragrunt orchestrates their  applications.

 

9. In the terminal, enter the following command to apply your infrastructure using Terragrunt:

```

```

[Copy code](https://cloudacademy.com/lab/syncing-modules-with-outputs-using-terragrunt-gcp/passing-outputs-between-gcp-modules-with-terragrunt/?context_id=4773&context_resource=lp#)

```
terragrunt run-all apply
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.31.49 PM-d1a5583a-866d-4ae2-aa30-86219fe0771c.png)

The initial output will prompt you for confirmation. `Group 1` is the `network` module, followed by `gce` in `Group 2`.

You do not need to initialize the project using the **init** command because the **apply** command will automatically perform the initialization of each module before  applying the infrastructure. As mentioned previously, the **network** module must be applied in order for its output variable `subnetwork_id` can be generated.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.32.59 PM-ac1ab6fc-34e8-4472-968e-c7f25ba7ec0a.png)

The **network** module is applied successfully, and the `subnetwork_id `is generated.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.33.08 PM-17de10ae-7195-4c5d-a313-2cb47380e525.png)

Up next, the **gce** module is applied, and as you will notice in the output, the `subnetwork_id `variable is utilized.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-06 at 7.33.24 PM-7eaac2f2-9aeb-46af-a56d-cad3a64e14f8.png)

Both modules are applied successfully, in the correct order.

 

### Summary

In this lab step, you learned how to use Terragrunt to establish  dependencies between cloud resources and pass data between Terraform  modules.