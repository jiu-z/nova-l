git pull && terraform init && terraform apply -auto-approve
git add . && git commit -m update && git push


google_firebase_project_location問題

```
│ Warning: Deprecated Resource
│ 
│   with google_firebase_project_location.basic,
│   on main.tf line 41, in resource "google_firebase_project_location" "basic":
│   41: resource "google_firebase_project_location" "basic" {
│ 
│ `google_firebase_project_location` is deprecated in favor of explicitly configuring `google_app_engine_application` and
│ `google_firestore_database`. This resource will be removed in the next major release of the provider.
│ 
│ (and 2 more similar warnings elsewhere)
╵
╷
│ Error: Error waiting to create ProjectLocation: Error waiting for Creating ProjectLocation: Error code 5, message: [ProvisionWorkflow RepairStorageBucket] Catching the NOT_FOUND error.
│ 
│   with google_firebase_project_location.basic,
│   on main.tf line 41, in resource "google_firebase_project_location" "basic":
│   41: resource "google_firebase_project_location" "basic" {
```