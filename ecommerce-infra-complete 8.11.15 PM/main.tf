module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "eks" {
  source = "./modules/eks"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  aws_region   = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
}

module "iam" {
  source = "./modules/iam"
  project_name = var.project_name
  cluster_name = module.eks.cluster_name
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  db_name = "ecommerce_db"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  alb_arn = module.eks.alb_arn
}