resource "google_storage_bucket" "raw_bucket" {
    name = "${var.project_id}-raw-data"
    location = var.region
    project = var.project_id
    force_destroy = true
    storage_class = "STANDARD"
    public_access_prevention = "enforced"
    uniform_bucket_level_access = true
    versioning {
      enabled = true
    }
    labels = {
      env = var.env
      region = var.region
    }
}

resource "google_storage_bucket" "preprocessed_bucket" {
    name = "${var.project_id}-preprocessed-data"
    location = var.region
    project = var.project_id
    force_destroy = true
    storage_class = "STANDARD"
    public_access_prevention = "enforced"
    uniform_bucket_level_access = true
    versioning {
      enabled = true
    }
    labels = {
      env = var.env
      region = var.region
    }
}

resource "google_storage_bucket" "backups" {
    name = "${var.project_id}-backups"
    location = var.region
    project = var.project_id
    force_destroy = true
    storage_class = "NEARLINE"
    public_access_prevention = "enforced"
    uniform_bucket_level_access = true
    lifecycle_rule {
      action {
        type = "Delete"
      }
      condition {
        age = 90 #will be suppress after 90 days
      }
    }
    labels = {
      env = var.env
      region = var.region
    }
}