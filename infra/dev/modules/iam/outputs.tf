output "bastion_sa_email" {
  description = "Bastion service account email"
  value       = google_service_account.bastion_sa.email
}