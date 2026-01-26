variable "project_id" {
    type = string
}
variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "env" {
  type = string 
}

variable "vpc_cidr_private" {
    type = list(string)
}
variable "vpc_cidr_public" {
    type =  list(string)
}
variable "zone" {
    type = string
}