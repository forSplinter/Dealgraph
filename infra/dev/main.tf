module "networking" {
    source = "./modules/networking/"
    env = var.env
    region = var.region
    project_id = var.project_id
    vpc_cidr_private = var.vpc_cidr_private
    vpc_cidr_public = var.vpc_cidr_public
    vpc_name = var.vpc_name
}
module "compute" {
    source = "./modules/compute/"
    env = var.env
    project_id = var.project_id
    zone = var.zone
    vm_ip_bastion = module.networking.network //TODO: make sure to change this one later, cause the name is not accurate and can lead to confusion 
    bastion_sa_email = module.iam.bastion_sa_email 
    privatenetwork_subnet = module.networking.privatenetwork_subnet[0]
    region = var.region
}
module "bastion-host_iap-tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "9.0.0"
  project = var.project_id
  network = module.networking.network
  service_accounts = ["rassou.muganga@gmail.com"]
  create_firewall_rule = false
  instances = [{
    name = module.compute.bastion_name
    zone = var.zone
  }]
  members = [
    "user:rassou.muganga@gmail.com"
  ]
}
module "iam" {
  source = "./modules/iam/"
  project_id = var.project_id
  env = var.env
  backups_name = module.storages.backups_name
}

module "storages" {
    source = "./modules/storages/"
    project_id = var.project_id
    env = var.env
    region = var.region
}
