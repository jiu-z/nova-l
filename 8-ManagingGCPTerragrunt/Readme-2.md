### Introduction

With some additional planning, Terragrunt can drastically reduce the  amount of configuring required to set up separate cloud environments.  Since Terragrun can serve as a wrapper around multiple Terraform  modules, developers can configure centralized environment variables that differ in each environment.

In this lab step, you will modify your environment configurations in  order to deploy a completely separate set of GCP resources using  Terragrunt.

 

### Instructions

1. In the terminal, enter the following command to create a separate **Production** subdirectory within the project:

```
cp -p -a ./development/. ./production/ \
&& sed -i 's/development/production/g' ./production/env_vars.yaml \
&& sed -i 's+10.0.0.0/24+10.1.0.0/24+g' ./production/env_vars.yaml \
&& sed -i 's+us-central1-a+us-central1-b+g' ./production/env_vars.yaml 
```

The first command makes a copy of the entire **deployment** directory and names the new directory **production**.

Each `sed` command that follows replaces a configuration value in the resulting **production/env_vars.yaml** file.

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113182530-7-e54a3e12-8fd8-4409-a900-33ac2e06a6e0.png)

2. Double-click on the **production/env_vars.yaml** file to open it in the editor:

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113182725-8-89d458a9-9ab0-4742-b68f-d4ebffbab2cf.png)

Notice the `environment` value is now set to `production`. The `ip_cidr_range` reflects a new CIDR block and the GCE module's `zone` value is now set to `us-central1-b`. 

With the differing values in this file, Terragrunt will spin up an  entirely separate set of resources in a different GCP zone and IP  range. 

3. In the terminal, run the following command, followed by *y* at the prompt to observe the deployment of the two separate environments at the same time:

```
terragrunt run-all apply
```

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113183012-9-df223d18-6f66-4796-97f5-5cab1b9dc89c.png)

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220113183050-10-e22982e6-d6c4-44db-951f-1648f11bbea5.png)

The **network** and **gce** resources in the **development** environment will show no changes. 

![alt](https://assets.cloudacademy.com/bakery/media/uploads/content_engine/image-20220117173455-1-a73ac1bb-7cb9-4cb0-a04f-d5c71cc01fe8.png)Meanwhile, the **production network**, **subnetwork**, and **labserver** resources are created successfully in their environment. The screenshot above indicates the successful **gce** module creation.

You now have two logically separated GCP environments that access the same module definitions, but can be uniquely configured in their  respective **env_vars.yaml** files.

Going forward, the following command can be used to apply changes to each environment separately:

```
terragrunt run-all apply --terragrunt-working-dir production
```

The command above will deploy changes to the `production` environment only using the `--terragrunt-working-dir` option. Keep in mind that this command would need to be run at the root, **terraform-gcp** directory.

###  

### Summary

In this lab, you learned how to quickly replicate GCP resource  configurations in a logically separate environment by using Terragrunt  environment variables. You also successfully configured similar  resources in two separate environments and imported remote GCP resource  modules from GitHub. 