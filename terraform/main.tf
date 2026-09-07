module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.vpc.vpc_id
  subnet_1_id     = module.vpc.public_subnet_1_id
  subnet_2_id     = module.vpc.public_subnet_2_id
  certificate_arn = module.acm.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id = module.vpc.vpc_id

  subnet_1_id = module.vpc.public_subnet_1_id
  subnet_2_id = module.vpc.public_subnet_2_id

  alb_security_group_id = module.alb.alb_security_group_id

  ecr_repository = module.ecr.repository_url

  target_group_arn = module.alb.target_group_arn
}

module "route53" {
  source = "./modules/route53"

  domain_name               = "shoshin.org.uk"
  domain_validation_options = module.acm.domain_validation_options

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "acm" {
  source = "./modules/acm"

  domain_name             = "shoshin.org.uk"
  validation_record_fqdns = module.route53.acm_validation_record_fqdns
}
