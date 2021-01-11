module "main_vpc" {
  source      = "../modules/vpc"
  project_prefix = local.project_prefix
  vpc_cidr    = local.vpc.cidr
  public_subnet_cidr = local.vpc.subnets.public.cidr
  private_subnet_cidr = local.vpc.subnets.private.cidr
}

module "key_pair" {
  source      = "../modules/key_pairs"
  project_prefix = local.project_prefix
  kp_name = "tenpo-cl-dev-kp.pub"
}

module "bastion_server" {
  source        = "../modules/ec2"
  key_pair_name = module.key_pair.key_pair_name
  project_prefix = local.project_prefix
  vpc_id        = module.main_vpc.vpc_id
  server_name   = local.servers.bastion.name
  instance_type = local.servers.bastion.instance_type
  purpose       = local.servers.bastion.purpose
  subnet_type   = local.servers.bastion.subnet_type
  subnet_id     = module.main_vpc.public_subnet_id
  private_ip    = local.servers.bastion.private_ip
  with_elastic_ip = local.servers.bastion.with_elastic_ip 
  open_ports    = local.servers.bastion.open_ports
}

module "api_server" {
  source        = "../modules/ec2"
  key_pair_name = module.key_pair.key_pair_name
  project_prefix = local.project_prefix
  vpc_id        = module.main_vpc.vpc_id
  server_name   = local.servers.api.name
  instance_type = local.servers.api.instance_type
  purpose       = local.servers.api.purpose
  subnet_type   = local.servers.api.subnet_type
  subnet_id     = module.main_vpc.private_subnet_id
  private_ip    = local.servers.api.private_ip
  with_elastic_ip = local.servers.api.with_elastic_ip 
  open_ports    = local.servers.api.open_ports
}

module "pg_server" {
  source        = "../modules/ec2"
  key_pair_name = module.key_pair.key_pair_name
  project_prefix = local.project_prefix
  vpc_id        = module.main_vpc.vpc_id
  server_name   = local.servers.pg.name
  instance_type = local.servers.pg.instance_type
  purpose       = local.servers.pg.purpose
  subnet_type   = local.servers.pg.subnet_type
  subnet_id     = module.main_vpc.private_subnet_id
  private_ip    = local.servers.pg.private_ip
  with_elastic_ip = local.servers.pg.with_elastic_ip 
  open_ports    = local.servers.pg.open_ports
}

module "elb_api" {
  source        = "../modules/elb"
  project_prefix = local.project_prefix
  instance_ids  = [module.api_server.instance_id]
  subnet_ids    = [module.main_vpc.public_subnet_id]
}


output "elb_api_dns" {
  value = module.elb_api.elb_api_dns
}
