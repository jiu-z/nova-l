### Introduction

Terraform provisioners can be useful in preparing your cloud  resources for service and provide developers with a way to expand the  functionality of Terraform's declarative model.

Although it is recommended that developers seek out other techniques  first and leave provisioners as the last resort, the following are  possible with Terraform provisioners:

- Passing data into virtual machines and other compute resources
- Performing configuration management with third-party software
- Establishing or cleaning up additional resource configurations

In Terraform, there are three generic provisioners: [file](https://www.terraform.io/docs/language/resources/provisioners/file.html), [local-exec](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html), and [remote-exec](https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html).

This lab will use the **local-exec** provisioner since  it does not require any other configuration. A local-exec provisioner  runs commands on your local machine. These can include third-party CLI  tools like `docker` or `gcloud`.

The **file** provisioner can be used to store files in a resource like a Cloud Engine instance. A **remote-exec** provisioner can be used to perform commands within the instance  directly. To allow this level of configuration, they both require an  additional connection block to access the resource, which is outside the scope of this lab.

*Note*: The solution discussed in this lab step is for  demonstration purposes only and can be accomplished with more  sustainable techniques.

In this lab step, you will learn how to configure provisioners to perform actions on a Cloud Storage bucket.

 

### Instructions

1. To begin configuring your Terraform project, expand the **terraform-gcp** directory under **PROJECT** and double-click on **main.tf**:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-11-10%20at%204.54.27%20PM-33a7cf13-0966-4059-8d48-818850a76b83.png)

The empty file will open in the IDE editor.

 

2. Paste the following block into the **main.tf** file, and replace the instance of `RANDOM_CHARS` with a few random characters:

```bash

```

[Copy code](https://cloudacademy.com/lab/working-with-terraform-provisioners-in-gcp/creating-a-terraform-provisioner-in-gcp/?context_id=4773&context_resource=lp#)

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
32
33
34
35
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
  project = "cal-1707-53389b4a9c53"
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {
  name     = "file-store-RANDOM_CHARS" # Replace with random characters
  location = "US"
  # Creation-time Provisioner
  provisioner "local-exec" {
    command = "gsutil cp $OBJECT gs://$BUCKET"
    environment = {
      BUCKET = self.name # Equivalent to "google_storage_bucket.file-store.name"
      OBJECT = "test.txt" # Path to local file
    }
  }
  
  # Destroy-time Provisioner
  provisioner "local-exec" {
    when = destroy
    command = "gsutil rm gs://$BUCKET/$OBJECT"
    environment = {
      BUCKET = self.name
      OBJECT = "test.txt"
    }
  }
}
```

The single resource defined in this configuration is the Cloud Storage `file-store-xxxx` bucket. Within the resource block, there are two provisioners, both with the type `local-exec`.

Both provisioners share the same `command` and `environment` configurations. The `command` setting holds the command to run on your local machine. Environment  variables scoped to the provisioner can be declared and accessed within  the `command` setting using a dollar sign: `$VARIABLE_NAME`.

Both `environment` blocks contain the same `test.txt` path for the `OBJECT` and a `BUCKET` variable set to `self.name`. Expressions in provisioner blocks cannot refer to their parent resource by name, so they must use the `self` object to access dynamic values of the resource they're defined within. In the example above, `self` is equal to `google_storage_bucket.file-store` and `self.name` is equivalent to the `google_storage_bucket.file-store.name` expression.

These provisioners are examples of a [creation-time provisioner](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#creation-time-provisioners) and a [destroy-time provisioner](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#destroy-time-provisioners).

In the first provisioner, the absence of the `when = destroy` configuration indicates it will run during the creation of the resource and *after* the resource has been created.

In the second provisioner, you'll notice the `when = destroy` configuration. This setting declares that the provisioner will run during the destroy process of a resource and *before* the resource is deleted.

Each provisioner makes use of the `gsutil` CLI tool, which allows you to interact with Google Cloud Storage directly. The creation-time provisioner uses the `cp` command to copy a local `test.txt` file into the newly created bucket. The destroy-time provisioner uses the `rm` command to remove the specific `test.txt` file from the bucket before it is deleted.

***Note\***: Destroy-time provisioners will only  run if they exist in the configuration at the time the cloud resource is destroyed. In Terraform, you can delete the resource definition to  delete the resource, but the destroy-time provisioner will not run. In  the case of deleting Cloud Storage buckets, if the bucket is not empty  upon deletion, it will return an error.

 

 

3. In the terminal window, enter the following command to change into the `terraform-gcp` directory:

```bash

```

[Copy code](https://cloudacademy.com/lab/working-with-terraform-provisioners-in-gcp/creating-a-terraform-provisioner-in-gcp/?context_id=4773&context_resource=lp#)

```
1
cd terraform-gcp
```

 

4. Enter the command `terraform init` in the terminal to initialize the directory to be used by Terraform.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-11-10%20at%205.52.47%20PM-bd4264fb-e3c2-46d6-adc1-43c312fd5a19.png)

 

5. Enter the command `terraform apply` in the terminal.

You will be presented with the deployment plan which includes the Cloud Storage Bucket.

 

6. Enter *yes* when prompted to proceed with the deployment:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-12-01%20at%204.11.03%20PM-34bfb7ca-c35d-48ab-b608-655c329d3296.png)

The `file-store` bucket is created, followed by the first provisioner:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-12-01%20at%204.22.38%20PM-a3dca6d4-9df2-4dbb-91e6-ea574d5fc892.png)

The first provisioner has run successfully. The `gsutil cp` command is executed, copying the `test.txt` file into the `file-store` bucket as a part of its creation process.

###  

7. To see the destroy-time provisioner in action, locate the `file-store` bucket `name` property and replace the random characters with a new set of random characters:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-12-01%20at%204.28.11%20PM-aac2a905-a57f-4458-ac34-e758faac187b.png)

The bucket name was previously, `file-store-o0op`. In the example above, it has been renamed to `file-store-new191`.

In Terraform, the renaming of a Cloud Storage bucket will  automatically result in a replacement action. This includes destroying  the `file-store-o0op` bucket, and creating a new `file-store-new191` bucket in its place.

As stated previously, the `when = destroy` setting means  the provisioner will run on a resource destroy action, but destroy-time  provisioners will run only if they exist in the configuration at the  time the cloud resource is destroyed. Simply deleting the configuration  of the bucket will not run the destroy-time provisioner.

 

8. Run `terraform apply` in the terminal window, followed by a *yes* to confirm the replacement action:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen%20Shot%202021-12-01%20at%204.24.14%20PM-6c83bc3f-5b94-49af-9802-5b64c9c80bef.png)

The following log output will be displayed:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/Screen Shot 2021-12-01 at 4.24.41 PM-e35ed7f2-4fc0-44c0-82fb-2bea694387e8.png)

This time, both provisioners are executed. First, the destroy-time provisioner runs the `gsutil rm` command to remove the specific `test.txt` file from the `file-store-o0op` bucket before it is deleted. The bucket is then deleted with no issue.

The creation-time provisioner runs immediately after, performing the same `gsutil cp` command to add the `test.txt` file to the newly created `file-store-new191` bucket.

 

### Summary

In this lab step, you learned how to configure Terraform provisioners to perform actions on a Cloud Storage bucket.