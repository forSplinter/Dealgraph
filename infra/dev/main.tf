module "networking" {
    source = "./modules/networking/"
    env = var.env
    region = var.region
    project_id = var.project_id
    vpc_cidr_private = var.vpc_cidr_private
    vpc_cidr_public = var.vpc_cidr_public
    vpc_name = var.vpc_name
}
module "bastion-host_iap-tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "9.0.0"
  project = var.project_id
  network = module.networking.network
  service_accounts = ["rassou.muganga@gmail.com"]
  create_firewall_rule = false
  instances = [{
    name = "${var.env}-bastion-nfs"
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
}
