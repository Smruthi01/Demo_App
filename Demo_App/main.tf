
module "networks" {
  source = "./modules/networks"
  cidr_block_pvtsub4=var.cidr_block_pvtsub4
  vpc_name=var.vpc_name
  cidr_block_pubsub=var.cidr_block_pubsub
  cidr_block_pubsub2=var.cidr_block_pubsub2
  cidr_block_pvtsub1=var.cidr_block_pvtsub1
  pub_subnet2_name=var.pub_subnet2_name
  cidr_block_pvtsub5=var.cidr_block_pvtsub5
  az-2=var.az-2
  az-1=var.az-1
  private_subnet1_name=var.private_subnet1_name
  alltraffic_cidr=var.alltraffic_cidr
  az-3=var.az-3
  private_rtb_db_name=var.private_rtb_db_name
  cidr_block_vpc=var.cidr_block_vpc
  private_subnet3_name=var.private_subnet3_name
  cidr_block_pvtsub3=var.cidr_block_pvtsub3
  public_rtb_name=var.public_rtb_name
  security_grp=var.security_grp
  private_subnet2_name=var.private_subnet2_name
  cidr_block_pvtsub2=var.cidr_block_pvtsub2
  private_rtb_name=var.private_rtb_name
  private_rtb_withoutnat=var.private_rtb_withoutnat
  pub_subnet_name=var.pub_subnet_name
  private_subnet4_name=var.private_subnet4_name
  private_subnet5_name=var.private_subnet5_name
  AWS_REGION=var.AWS_REGION
  AMIS=var.AMIS
  nat_name=var.nat_name
  elastic_ip=var.elastic_ip
  igw_name=var.igw_name

   
}

module "instances" {
  source = "./modules/instances"
  vpc_id= module.networks.vpc_id
  pubsub1_id = module.networks.pubsub_id
  privsub1_id = module.networks.privsub1_id
  instance_keypair_name = var.instance_keypair_name
  instance_type = var.instance_type
  ami           = var.AMIS
  ec2-sg = var.ec2-sg
  INSTANCE_USERNAME       = var.INSTANCE_USERNAME
  instance_public_name=var.instance_public_name
  instance_private_name=var.instance_private_name
  instance_keypair_name_local=var.instance_keypair_name_local
  bucketwt_id=module.s3-bucket.bucketwt_id
  default_sg_id=module.networks.default_sg_id
  AMIS=var.AMIS
  dbsecret_instance_profile=module.rds.dbsecret_instance_profile
  # public_ip = 
  # s3_bucket = module.s3-bucket

  
}

module "s3-bucket" {
  source = "./modules/s3-bucket"
  s3_name =var.s3_name  
  acm_cert_id=  module.dns.acm_cert_id 
  acm_cert_arn=module.dns.acm_cert_arn
  
}

module "rds" {
  source = "./modules/rds"
  vpc_id= module.networks.vpc_id
  privsub4_id = module.networks.privsub4_id
  privsub5_id = module.networks.privsub5_id
  az-1=var.az-1
  # db_username=var.db_username
  # db_password=var.db_password
  priv_ec2_id=module.instances.priv_ec2_id
  ec2_sec_grp_id=module.instances.ec2_sec_grp_id
  
}

module "api-gw" {
  source = "./modules/api-gw"
  api_custom_domain=var.api_custom_domain
  dns_name=var.dns_name
  dns_zone=var.dns_zone
  api= var.api
  stage-name=var.stage-name
  lb_dns=var.lb_dns
 acm_cert_arn=module.dns.acm_cert_arn
 api_vpc_link=module.nlb.api_vpc_link
 acm_cert_id=module.dns.acm_cert_id
 vpclink_id=module.nlb.vpclink_id


  
}

module "dns" {
  source = "./modules/dns"
  dns_zone=var.dns_zone
  lb_dns=var.lb_dns
  dns_name=var.dns_name
  cloudfront_domainname=module.s3-bucket.cloudfront_domainname
  cloudfront_hostedzoneid=module.s3-bucket.cloudfront_hostedzoneid
  api_vpc_link=module.nlb.api_vpc_link
  //apigway_regional_domain_name=module.api-gw.apigway_regional_domain_name
  apigw_domain_regional_zone_id=module.api-gw.apigw_domain_regional_zone_id
  WT_nlb_dns_name=module.nlb.WT_nlb_dns_name
  custom_apigw_id=module.api-gw.custom_apigw_id
  apicustdom=var.apicustdom
  api_custom_domain=var.api_custom_domain
  apigway_regional_domain_name=module.api-gw.apigway_regional_domain_name
  cf_dns=module.s3-bucket.cf_dns
  cloudfront_id=module.s3-bucket.cloudfront_id

  //nlb
}

module "nlb" {
  source = "./modules/nlb"
  privsub1_id = module.networks.privsub1_id
  privsub2_id = module.networks.privsub2_id
  vpc_id= module.networks.vpc_id
  priv_instance = module.instances.priv_instance
  acm_cert_arn=module.dns.acm_cert_arn
  # nlb_arn = var.nlb_arn
  vpc-link=var.vpc-link
  priv_ec2_id=module.instances.priv_ec2_id

 
}

