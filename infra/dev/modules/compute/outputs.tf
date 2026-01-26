output "bastion_name" {
    description = "Bastion instance name"
    value = google_compute_instance.bastion.name
}

output "bastion_id" {
    description = "Bastion instance ID"
    value = google_compute_instance.bastion.id
}

output "bastion_zone" {
    description = "Bastion instance zone"
    value = google_compute_instance.bastion.zone
}