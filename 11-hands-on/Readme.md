5

## Deploy a Google Compute Engine Instance with Terraform Challenge

Experiencing issues? Report this checkpoint  



**Terraform Remote Backend Stored in Cloud Storage Bucket** 

In the root-level **terraform-gcp/main.tf** file, configure a prefix for the Google Cloud Storage backend with the following:

- **Prefix Name**: *"gcp-challenge"*

Google Cloud PlatformTerraformDevOps



**Defined GCE Module Input and Output Variables** 

In the **terraform-gcp/modules/gce** module directory, add the following changes to the **outputs.tf** and **variables.tf** files:

- variables.tf

  :

  - Declare a `string` type variable named `subnetwork` with the description `GCP Subnetwork Id`

- outputs.tf

  :

  - Declare an output variable named `instance_id` with the description, "ID of GCP instance" and the value of `google_compute_instance.webserver.id`

Google Cloud PlatformTerraformDevOps



**Defined Google Compute Engine Module** 

In the **terraform-gcp/modules/gce** directory, use the following GCE Terraform definition to create a `google_compute_engine` instance:

```
resource "google_compute_instance" "webserver" {
  name         = #VARIABLE
  machine_type = #VARIABLE
  zone         = #VARIABLE

  boot_disk {
    initialize_params {
      image = #VARIABLE
    }
  }

  network_interface {
    subnetwork = #VARIABLE
    access_config {}
  }
}
```

Access the `var` object to assign each variable in **variables.tf** to the matching parameters above.

Google Cloud PlatformTerraformDevOps



**GCE Module Utilized in Terraform Project** 

In the root-level **terraform-gcp/main.tf** file, declare an instance of the **gce** module by adding a `module` block with the identifier `webserver`.

Configure the resource with the following parameters:

- **source**: *"./modules/gce"*
- **name**: *"ca-webserver"*
- **machine_type**: *"f1-micro"*
- **zone**: *"us-central1-a"*
- **image**: *"debian-cloud/debian-11"*
- **subnetwork**: *google_compute_subnetwork.ca-subnetwork.id*

*Note*: Be sure to maintain quotation marks for parameters that require string values.

Google Cloud PlatformTerraformDevOps



**Created a GCE Instance Using Terraform** 

In the terminal change into the **terraform-gcp** directory, then initialize your Terraform project and apply the project  configurations using the correct Terraform CLI commands.

Validate this final check after all resources have been deployed successfully.

Google Cloud PlatformTerraformDevOps