provider "aws" {
  region = var.aws_region
}

# 1️⃣ Networking (MUST come first)
module "networking" {
  source = "./modules/networking"
}

# 2️⃣ Security (depends on networking)
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

# 3️⃣ Compute (depends on networking + security)
module "compute" {
  source    = "./modules/compute"
  vpc_id    = module.networking.vpc_id
  subnets   = module.networking.public_subnets
  alb_sg_id = module.security.alb_sg_id
  ec2_sg_id = module.security.ec2_sg_id
}

