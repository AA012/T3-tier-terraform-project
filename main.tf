# used to determine which aws resources we want to create
provider "aws" {
  region = "us-east-1"

}

#create an s3 bucket for storing 
terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-remote"
    encrypt        = true
    key            = "jupiter/statefile"
    region         = "us-east-1"
    dynamodb_table = "jupiter-state-locking"
    #use_lockfile = true  #S3 native locking
  }
}

module "vpc" {
  source                    = "./vpc"
  tags                      = local.project_tags
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  availability_zone         = var.availability_zone
  db_subnet_cidr_block      = var.db_subnet_cidr_block
}

#create the ALB module
module "alb" {
  source                    = "./ALB"
  vpc_id                    = module.vpc.vpc_id
  apci_jupiter_public_az_1c = module.vpc.apci_jupiter_public_az_1c
  apci_jupiter_public_az_1d = module.vpc.apci_jupiter_public_az_1d
  tags                      = local.project_tags
  certificate_arn           = var.certificate_arn
  ssl_policy                = var.ssl_policy
}
#create the autoscalling module
module "auto-scalling" {
  source                    = "./auto-scalling"
  apci_jupiter_alb_sg       = module.alb.apci_jupiter_alb_sg
  apci_jupiter_tg           = module.alb.apci_jupiter_tg
  apci_jupiter_public_az_1c = module.vpc.apci_jupiter_public_az_1c
  apci_jupiter_public_az_1d = module.vpc.apci_jupiter_public_az_1d
  instance_type             = var.instance_type
  key_name                  = var.key_name
  vpc_id                    = module.vpc.vpc_id
  image_id                  = var.image_id
}

#create the compute module
module "compute" {
  source                     = "./compute"
  tags                       = local.project_tags
  apci_jupiter_private_az_1c = module.vpc.apci_jupiter_private_az_1c
  apci_jupiter_private_az_1d = module.vpc.apci_jupiter_private_az_1d
  apci_jupiter_public_az_1c  = module.vpc.apci_jupiter_public_az_1c
  apci_jupiter_public_az_1d  = module.vpc.apci_jupiter_public_az_1d
  instance_type              = var.instance_type
  key_name                   = var.key_name
  vpc_id                     = module.vpc.vpc_id
  image_id                   = var.image_id
}

#create the rds module 
module "rds" {
  source                       = "./rds"
  tags                         = local.project_tags
  vpc_id                       = module.vpc.vpc_id
  apci_jupiter_bastion_sg      = module.compute.apci_jupiter_bastion_sg
  db_username                  = var.db_username
  apci_jupiter_db_subnet_az_1c = module.vpc.apci_jupiter_db_subnet_az_1c
  apci_jupiter_db_subnet_az_1d = module.vpc.apci_jupiter_db_subnet_az_1d
}

#create the route 53 module
module "route53" {
  source                   = "./route53"
  apci_jupiter_alb         = module.alb.apci_jupiter_alb_name
  dns_name                 = var.dns_name
  apci_jupiter_alb_zone_id = module.alb.apci_jupiter_alb_zone_id
  dns_zone_id              = var.dns_zone_id
}

