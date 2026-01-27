resource "google_bigquery_dataset" "analytics" {
  dataset_id  = "${var.env}_dealgraph_analytics"
  project     = var.project_id
  location    = var.region 
  description = "DealGraph analytics dataset"
  
  labels = {
    env = var.env 
  }
  
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = var.owner_gcp
  }
  
  access {
    role          = "roles/bigquery.dataViewer"
    user_by_email = var.kafka_sa_email
  }
  
  access {
    role          = "READER"
    special_group = "projectReaders"
  }
}

resource "google_bigquery_dataset" "logs" {
  dataset_id                  = "${var.env}_dealgraph_logs"
  project                     = var.project_id 
  location                    = var.region
  description                 = "Just some logs"
  default_table_expiration_ms = 7776000000 
  
  labels = {
    env     = var.env
    purpose = "logs"
  }
  
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = var.owner_gcp
  }
  
  access {
    role          = "roles/bigquery.dataEditor"
    user_by_email = var.kafka_sa_email
  }
  
  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }
}