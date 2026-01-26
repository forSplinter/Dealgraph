output "network" {
    value = google_compute_network.vpc_network.self_link
    description = "Vpc have being created"
}

output "network_id" {
    value = google_compute_network.vpc_network.id
    description = "VPC ID being created"
}

output "privatenetwork_subnet" {
    value = google_compute_subnetwork.vpc_private_subnet.*.name
    description = "Private subnet"
}

output "NAT-IPs" {
    value = google_compute_address.address.*.address
}