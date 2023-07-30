### Introduction

Once you've learned how to configure Terraform modules, it's a  natural progression to begin storing them in remote sources such as  GitHub. By storing your Terraform modules remotely, you can reduce the  number of configurations required by other developers, and also utilize  Terragrunt to configure only the values that differ between environments and projects.

In this lab step, you will learn how to import resource  configurations from a remote Terraform module source and deploy them  into a Google Cloud Platform environment with Terragrunt.

 

### Instructions

1. Expand the **terragrunt-gcp** directory below **PROJECT** to begin reviewing the Terraform project:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113162455-1-4cbe90fb-5291-40c8-b395-f9e71932a206.png)

This directory does not contain the Terraform configuration files  seen in previous labs because you will be importing modules from a  remote GitHub repository.

The **development** directory contains two subdirectories, **gce,** and **network**. They represent the resources that will make up your environments, a  Google Cloud network, and a Google Compute Engine instance. Both  subdirectories contain a **terragrunt.hcl** file that is  configured to import each of the respective remote modules.  This development directory represents the environment you will be  deploying at the end of this lab step. Later in this lab, you will  configure a separate **production** directory with unique configuration values. 

The **env_vars.yaml** file, will contain resource values that will differ between the two environments, but for now, it is only  used to configure the development environment. Each environment  subdirectory will have an environment variables file like this one.

Lastly, the environment's **terragrunt.hcl** file is where you will configure the remote state location, provider settings, and GCP credentials for each environment.

 

2. To learn how the development environment will pass in variables, double-click on the **development/terragrunt.hcl** file to open it in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113173736-2-8b65a2dd-1e35-4443-af07-59cf7526298a.png)

 

3. Paste the following code into the **development/terragrunt.hcl** file:

```
remote_state {
  backend = "gcs"
  config = {
    bucket = "calabs-bucket-1690694189"
    prefix = "${local.env_vars.environment}/${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-2806-d253926d684d"
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
  project = "cal-2806-d253926d684d"
  region = "us-central1"
}
  EOF
}
 
# Collect values from env_vars.yaml and set as local variables
locals {
  env_vars = yamldecode(file("env_vars.yaml"))
}
```

You should be familiar with the code above, as it utilizes the standard `remote_state` and `generate` blocks to establish a remote backend source to store your project state and create the necessary GCP provider credentials. The GCS bucket that  serves as the remote state source has been created on your behalf at the start of this lab. For a refresher, refer to the [Centralizing Remote State with Terragrunt in GCP](https://cloudacademy.com/lab/centralizing-remote-state-with-terragrunt-in-gcp/) lab. 

The `locals` configuration block establishes an `env_vars` object. The `yamldecode` function accepts the `env_vars.yaml` file as input and decodes the YAML into the object. With this  configuration, the environment variables stored in that file can be  accessed as local variables in this `terragrunt.hcl` file.

The first occurrence of this `locals.env_vars` object in action is in the `remote_state` block. The `environment` key is used to dynamically name the `prefix` name for the remote state. 

 

5. Double-click on the **development/env_vars.yaml** file to open it in the editor.

 

6. Paste the following code into the **development/env_vars.yaml** file:

```
# Environment
environment: "development"
 
# Network Module
ip_cidr_range: "10.0.0.0/24"
region: "us-central1"
 
# GCE Module
server_count: 1
server_name: "labserver"
machine_type: "f1-micro"
zone: "us-central1-a"
image: "debian-cloud/debian-11"
```

The YAML code you pasted in will be used as input variables for your resource modules.

To understand how these will be used in the resource modules, you  must first understand how those modules will be imported into this  project.

7. Double-click on the **development/gce/terragrunt.hcl** file:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113175055-3-f2742fe2-a575-47d6-88c7-837a78d54c1b.png)

At the top of the file, you will see the `terraform` block and `source` property. The value for this property points at a pre-configured, stable release stored in a public GitHub repository. `v0.0.2` is the release tag, and the `/gce` path ahead of this tag indicates which module within that repository to use. 

These modules are stored in a public repository named [cloudacademy / terraform-gcp-calabmodules](https://github.com/cloudacademy/terraform-gcp-calabmodules)


Feel free to navigate to the repository and explore the two modules defined within. If you jump to the **/gce/main.tf** file in this repository, you will find the module definition:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113175537-4-6fb07a1c-d517-4241-9a3a-dae526e40b97.png)

Back in the code editor, you will notice that each one of the above variables will match up with the `inputs `object defined in the **development/gce/terragrunt.hcl** file. The `local.env_vars `object described earlier is accessed and the values of each environment variable are passed in as input. 

As seen in previous labs, the `dependency` block points at the network module that is defined in the same repository in order to receive any required module outputs. 

Now that you understand the responsibilities of each file, it's time to deploy the resource into the GCP environments.

 

8. In the terminal, enter the following command to change directories and deploy your resources:

```
cd terragrunt-gcp \
&& terragrunt run-all apply
```

 

9. Enter *y* at the prompt to deploy your development environment resources:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113181834-6-15f9737e-e378-4ef7-9ae2-21edec4768b2.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-13 at 4.50.01 PM-ea3086ae-d5e1-4b20-846a-59f650dceb91.png)

The **network** module completes first and the **subnetwork_id** output is created.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2022-01-13 at 4.49.51 PM-211eec48-c0f9-4b78-808d-77f9ab4a2b57.png)

Up next, the **gce** module completes and a single Google Compute Engine instance is created, which indicates that your deployment was successful.

 

### Summary

In this lab step, you imported remote Terraform module definitions  from a public GitHub repository and used environment variables to deploy them into a Google Cloud Platform environment.