resource "google_compute_instance" "bastion" {
    name = "${var.env}-bastion-vm"
    project = var.project_id
    machine_type = "e2-micro"
    zone = var.zone
    tags = ["allow-ssh"]

    boot_disk {
      initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2204-lts"
        size = 10
        type = "pd-standard"
        labels = {
          env = var.env
          env = var.region
        }
      }
    }

    metadata = {
      enable-oslogin = "TRUE"
      block-project-ssh-keys = "TRUE"
    }

    network_interface {
      network =  var.vm_ip_bastion
      subnetwork = var.privatenetwork_subnet
      subnetwork_project = var.project_id
    }

    scheduling {
      automatic_restart =  true
      on_host_maintenance = "MIGRATE"
      preemptible = false 
      provisioning_model = "STANDARD"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot = true 
      enable_vtpm = true
    }

    service_account {
      email = var.bastion_sa_email
      scopes = [
        "cloud-platform"
      ]
    }

}

#TODO: VM for kafka confluent and for Neo4j