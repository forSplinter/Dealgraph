resource "google_project_service" "project" {
  for_each           = toset(local.apis)
  project            = local.project_id
  service            = each.key
  disable_on_destroy = false

}

