locals {
  project = "tenpo-cl"
  environment = "dev"
  project_prefix = "${local.project}-${local.environment}"

  vpc = {
    cidr = "192.168.0.0/16"
    subnets = {
      private = {
        cidr = "192.168.10.0/24"
      }
      public = {
        cidr = "192.168.20.0/24"
      }
    }
  }

  servers = {
    bastion = {
      name = "bastion"
      instance_type = "t2.micro"
      subnet_type = "public"
      purpose = "connection"
      private_ip = "192.168.10.11"
      with_elastic_ip = true 
      open_ports = [22]
    }
    api = {
      name = "api"
      instance_type = "t2.micro"
      subnet_type = "private"
      purpose = "web"
      private_ip = "192.168.20.11"
      with_elastic_ip = false
      open_ports = [22, 80]
    }
    pg = {
      name = "pg"
      instance_type = "t2.micro"
      subnet_type = "private"
      purpose = "database"
      private_ip = "192.168.20.12"
      with_elastic_ip = false
      open_ports = [22, 5432]
    }
  }
}
