output "bastion_sa_email" {
  description = "Bastion service account email"
  value       = google_service_account.bastion_sa.email
}

output "kafka_sa_email" {
  description = "kafka service account email"
  value = google_service_account.kafka_sa.email
}