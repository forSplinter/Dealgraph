resource "google_service_account" "bastion_sa" {
  account_id   = "${var.env}-bastion-sa"
  display_name = "Bastion Host Service Account"
  project = var.project_id
}

locals {
  bastion_sa_roles = [
    "roles/logging.logWriter",      
    "roles/monitoring.metricWriter",
    "roles/storage.objectCreator",
    "roles/compute.viewer"
  ]
}

resource "google_project_iam_member" "bastion_sa_roles" {
  for_each = toset(local.bastion_sa_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.bastion_sa.email}"
}

resource "google_storage_bucket_iam_member" "bastion_backups" {
    bucket = var.backups_name
    role = "roles/storage.objectCreator"
    member = "serviceAccount:${google_service_account.bastion_sa.email}"
}

#TODO: create the iam roles for each service that will use our api