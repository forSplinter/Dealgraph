output "raw_bucket_name"{
    description = "RAW bucket name"
    value = google_storage_bucket.raw_bucket.name
}

output "raw_bucket_url" {
    description = "value"
    value = google_storage_bucket.raw_bucket.url
}

output "preprocessed_bucket_name" {
    description = "Preprocessed bucket name"
    value = google_storage_bucket.preprocessed_bucket.name
}

output "preprocessed_bucket_url" {
    description = "value"
    value = google_storage_bucket.preprocessed_bucket.url
}

output "backups_name" {
    description = "Backup bucket name"
    value = google_storage_bucket.backups.name
  
}

output "backups_url" {
    description = "value"
    value = google_storage_bucket.backups.url
  
}