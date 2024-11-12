module "network" {
  source            = "./modules/network"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

module "security_group" {
  source              = "./modules/security_group"
  name                = "yasmin_checkpoint_home_exam_sg"
  description         = "Allow SSH"
  vpc_id              = module.network.vpc_id
  ingress_from_port   = 22
  ingress_to_port     = 22
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2_instance" {
  source             = "./modules/ec2"
  depends_on         = [module.network, module.security_group]
  ami                = var.ami
  instance_type      = var.instance_type
  subnet_id          = module.network.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  name               = var.name
  admin_role_name         = module.iam.admin_role_name
}

module "iam" {
  source = "./modules/iam"
}
