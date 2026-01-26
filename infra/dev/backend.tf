terraform {
  backend "gcs" {
    bucket = "deal-graph-terraform-state"
    prefix = "envs/dev"
  }
}