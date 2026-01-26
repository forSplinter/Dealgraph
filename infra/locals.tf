locals {
  project_id = "deal-graph"
  region     = "europe-west1"
  apis = [
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "logging.googleapis.com",
    "container.googleapis.com",
    "iap.googleapis.com",
    "compute.googleapis.com",
  ]
}
