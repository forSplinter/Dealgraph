#TODO:  networking
resource "google_compute_network" "vpc_network" {
    project = var.project_id
    name = "${var.env}-${var.vpc_name}"
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    delete_default_routes_on_create = true
}
#TODO: private and public subnet
resource "google_compute_subnetwork" "vpc_public_subnet" {
    count = length(var.vpc_cidr_public)
    name = "${var.env}-public-subnet-${count.index + 1}"
    ip_cidr_range = element(var.vpc_cidr_public, count.index)
    region = var.region
    network = google_compute_network.vpc_network.id
    private_ip_google_access =  true
    stack_type = "IPV4_ONLY"
  
}
resource "google_compute_subnetwork" "vpc_private_subnet" {
    count = length(var.vpc_cidr_private)
    name = "${var.env}-private-subnet-${count.index + 1}"
    ip_cidr_range = element(var.vpc_cidr_private, count.index)
    region = var.region
    network = google_compute_network.vpc_network.id
    private_ip_google_access = true
    stack_type = "IPV4_ONLY"
}

resource "google_compute_route" "public_route" {
    name = "${var.env}-network-route"
    dest_range = "0.0.0.0/0"
    network = google_compute_network.vpc_network.name
    next_hop_gateway = "default-internet-gateway"
    priority = 1000
  
}

resource "google_compute_firewall" "allow-internal" {
    name = "${var.env}-fw-internal-access"
    network = google_compute_network.vpc_network.id
    allow {
        protocol = "icmp"
    } 
    allow {
      protocol = "tcp"
      ports = ["0-65535"]
    }
    allow {
      protocol = "udp"
      ports = ["0-65535"]
    }
    source_ranges = var.vpc_cidr_private
}
#TODO: bastion and iap next 
resource "google_compute_firewall" "allow_ssh" {
    name = "${var.env}-fw-ssh"
    network = google_compute_network.vpc_network.id
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
    source_ranges = ["35.235.240.0/20"]
    target_tags = ["allow-ssh"]
}

#TODO: allow https before i forget
resource "google_compute_firewall" "allow_http" {
    name = "${var.env}-fw-http"
    network = google_compute_network.vpc_network.id
    allow {
      protocol = "tcp"
      ports = ["80", "443"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["api-server"]
  
}
# Allow kafka connect using firewal
resource "google_compute_firewall" "allow_kafka" {
    name = "${var.env}-fw-kafka"
    network = google_compute_network.vpc_network.id
    allow {
      protocol = "tcp"
      ports = ["8083", "9092"]
    }
    source_ranges = concat(var.vpc_cidr_public, var.vpc_cidr_private)
    target_tags = ["kafa-server"]
}

# Allow neo4j
resource "google_compute_firewall" "allow-neo4j" {
  name = "${var.env}-fw-neo4j"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports = ["7687", "7474"]
  }
  source_ranges = var.vpc_cidr_public
  target_tags = ["neo4j-server"]
}

#TODO: nat with is router
resource "google_compute_router" "router" {
    name = "${var.env}-router"
    region = var.region
    network = google_compute_network.vpc_network.id
  
}
resource "google_compute_address" "address" {
    count = 2
    name = "${var.env}-address-${count.index}"
    region = var.region
    lifecycle {
      create_before_destroy = true
    }
}

resource "google_compute_router_nat" "nat" {
    name = "${var.env}-nat"
    router = google_compute_router.router.name
    region = var.region

    nat_ip_allocate_option = "MANUAL_ONLY"
    nat_ips = google_compute_address.address.*.self_link
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    dynamic "subnetwork" {
        for_each = google_compute_subnetwork.vpc_private_subnet
        content {
          name = subnetwork.value.self_link
          source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
        }
      
    }
}