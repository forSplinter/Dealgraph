resource "google_service_account" "bastion_sa" {
  account_id   = "${var.env}-bastion-sa"
  display_name = "Bastion Host Service Account"
  project      = var.project_id
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
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.bastion_sa.email}"
}

#TODO: create the iam roles for each service that will use our api

resource "google_service_account" "neo4j_sa" {
  account_id   = "${var.env}-neo4j-sa"
  display_name = "neo4j VM service Account"
  project   = var.project_id
}

locals {
  neo4j_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

resource "google_project_iam_member" "neo4j_sa_roles" {
  for_each   = toset(local.neo4j_sa_roles)
  project = var.project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.neo4j_sa.email}"
}
locals {
  neo4j_bucket_roles = [
    "roles/storage.objectCreator", 
    "roles/storage.objectViewer"
  ]
}

resource "google_storage_bucket_iam_member" "neo4j_processed" {
  for_each = toset(local.neo4j_bucket_roles)
  bucket = var.preprocessed_bucket_name
  role = each.value
  member = "serviceAccount:${google_service_account.neo4j_sa.email}"
}

resource "google_storage_bucket_iam_member" "neo4j_backups" {
  for_each = toset(local.neo4j_bucket_roles)
  bucket = var.backups_name
  role = each.value
  member = "serviceAccount:${google_service_account.neo4j_sa.email}"
}

#kafka roles and blablabla 
resource "google_service_account" "kafka_sa" {
    account_id = "${var.env}-kafka-sa"
    display_name = "Kafka VM service account"
    project = var.project_id
}
locals {
  kafka_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/bigquery.dataEditor",
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser"
  ]
}
locals {
  kafka_bucket_roles = [
    "roles/storage.objectCreator", 
    "roles/storage.objectViewer"
  ]
}
resource "google_project_iam_member" "kafka_sa_roles" {
    for_each = toset(local.kafka_sa_roles)
    role = each.value
    member = "serviceAccount:${google_service_account.kafka_sa.email}"
    project = var.project_id
  
}
resource "google_storage_bucket_iam_member" "kafka_raw" {
    for_each = toset(local.kafka_bucket_roles)
    role = each.value
    bucket = var.raw_bucket_name
    member = "serviceAccount:${google_service_account.kafka_sa.email}"
}
#TODO: I also need to add the permission for bigQuery on kafka


#TODO: big flemme but i forget to do the iam role for bigqueri i will to that later or one day for ensure 
