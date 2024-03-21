module "network" {
  source = "./network"
}

module "instances" {
  source               = "./instances"
  vpc_id               = module.network.vpc_id
  first_web_subnet_id  = module.network.first_private_web_subnet_id
  second_web_subnet_id = module.network.second_private_web_subnet_id
}

module "load_balancers" {
  source    = "./loadbalancers"
  vpc_id    = module.network.vpc_id
  subnets   = [module.network.first_public_subnet_id, module.network.second_public_subnet_id]
  instances = module.instances.web_servers
}

module "databases" {
  source                = "./databases"
  vpc_id                = module.network.vpc_id
  first_rds_subnet_id   = module.network.first_private_rds_subnet_id
  second_rds_subnet_id  = module.network.second_private_rds_subnet_id
  web_security_group_id = module.instances.security_group_id
}

module "dns" {
  source                = "./dns"
  load_balancer         = module.load_balancers.load_balancer
  first_rds_subnet_id   = module.network.first_private_rds_subnet_id
  second_rds_subnet_id  = module.network.second_private_rds_subnet_id
  web_security_group_id = module.instances.security_group_id
}
