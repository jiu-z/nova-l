project_id           = "pacific-ethos-388512"
account_id_cloud_run = "cloud-run-custom-dev"

service_account_roles_permitions = [
  {
    account_id  = "custom1"
    role_id     = "cloud_run_basic_role"
    title       = "cloud_run_basic_role"
    description = "cloud_run_basic特定の権限を持つカスタムロール"
    permissions = ["recommender.locations.get",
      "recommender.locations.list",
      "recommender.runServiceCostInsights.get",
      "recommender.runServiceCostInsights.list",
      "recommender.runServiceCostInsights.update",
      "recommender.runServiceCostRecommendations.get",
      "recommender.runServiceCostRecommendations.list",
      "recommender.runServiceCostRecommendations.update",
      "recommender.runServiceIdentityInsights.get",
      "recommender.runServiceIdentityInsights.list",
      "recommender.runServiceIdentityInsights.update",
      "recommender.runServiceIdentityRecommendations.get",
      "recommender.runServiceIdentityRecommendations.list",
      "recommender.runServiceIdentityRecommendations.update",
      "recommender.runServiceSecurityInsights.get",
      "recommender.runServiceSecurityInsights.list",
      "recommender.runServiceSecurityInsights.update",
      "recommender.runServiceSecurityRecommendations.get",
      "recommender.runServiceSecurityRecommendations.list",
      "recommender.runServiceSecurityRecommendations.update",
      "resourcemanager.projects.get",
      "run.configurations.get",
      "run.configurations.list",
      "run.executions.delete",
      "run.executions.get",
      "run.executions.list",
      "run.jobs.create",
      "run.jobs.delete",
      "run.jobs.get",
      "run.jobs.getIamPolicy",
      "run.jobs.list",
      "run.jobs.run",
      "run.jobs.runWithOverrides",
      "run.jobs.setIamPolicy",
      "run.jobs.update",
      "run.locations.list",
      "run.operations.delete",
      "run.operations.get",
      "run.operations.list",
      "run.revisions.delete",
      "run.revisions.get",
      "run.revisions.list",
      "run.routes.get",
      "run.routes.invoke",
      "run.routes.list",
      "run.services.create",
      "run.services.createTagBinding",
      "run.services.delete",
      "run.services.deleteTagBinding",
      "run.services.get",
      "run.services.getIamPolicy",
      "run.services.list",
      "run.services.listEffectiveTags",
      "run.services.listTagBindings",
      "run.services.setIamPolicy",
      "run.services.update",
      "run.tasks.get",
      "run.tasks.list",
      "iam.serviceAccounts.actAs",
      "iam.serviceAccounts.get",
      "iam.serviceAccounts.list",
      "resourcemanager.projects.get",
      "eventarc.events.receiveEvent",
    "eventarc.events.receiveAuditLogWritten"]
  },
  {
    account_id  = "custom1"
    role_id     = "cloud_run_additional_role"
    title       = "cloud_run_additional_role"
    description = "cloud_run_additional特定の権限を持つカスタムロール"
    permissions = [
      "pubsub.topics.publish",
      "appengine.applications.get",
      "datastore.databases.get",
      "datastore.databases.getMetadata",
      "datastore.databases.list",
      "datastore.entities.allocateIds",
      "datastore.entities.create",
      "datastore.entities.delete",
      "datastore.entities.get",
      "datastore.entities.list",
      "datastore.entities.update",
      "datastore.indexes.list",
      "datastore.namespaces.get",
      "datastore.namespaces.list",
      "datastore.statistics.get",
      "datastore.statistics.list",
      "resourcemanager.projects.get",
      "composer.dags.execute",
      "composer.dags.get",
      "composer.dags.getSourceCode",
      "composer.dags.list",
      "composer.environments.get",
      "composer.environments.list",
      "composer.imageversions.list",
      "composer.operations.get",
      "composer.operations.list",
      "resourcemanager.projects.get",
      "serviceusage.quotas.get",
      "serviceusage.services.get",
      "serviceusage.services.list",
      "storage.objects.get",
      "logging.buckets.create",
      "logging.buckets.delete",
      "logging.buckets.get",
      "logging.buckets.list",
      "logging.buckets.undelete",
    "logging.buckets.update"]
  },
  {
    account_id  = "custom2"
    role_id     = "cloud_run_additional_role2"
    title       = "cloud_run_additional_role2"
    description = "cloud_run_additional特定の権限を持つカスタムロール"
    permissions = [
      "pubsub.topics.publish",
      "appengine.applications.get",
      "datastore.databases.get",
      "datastore.databases.getMetadata",
      "datastore.databases.list",
    "datastore.entities.allocateIds"]
  }
]
