variable "cidr_block_vpc" {}

variable "vpc_name" {}

# variable "my_ip" {
#     type = string
#     sensitive = true
  
# }
//variable "subnet_name" {}

variable "pub_subnet_name" {}

variable "pub_subnet2_name" {}

variable "private_subnet1_name" {}

variable "private_subnet2_name" {}

variable "private_subnet3_name" {}

variable "private_subnet4_name" {}

variable "private_subnet5_name" {}

variable "alltraffic_cidr" {}

variable "cidr_block_pubsub" {}
 
 variable "cidr_block_pubsub2" {}
variable "cidr_block_pvtsub1" {}

variable "cidr_block_pvtsub2" {}
variable "cidr_block_pvtsub3" {}

variable "cidr_block_pvtsub4" {}

variable "cidr_block_pvtsub5" {}

variable "AWS_REGION" {}

variable "AMIS" {
  
}

variable "az-1" {}

variable "az-2" {}
variable "az-3" {}
variable "igw_name" {}

variable "nat_name" {}

variable "public_rtb_name" {}


variable "private_rtb_name" {
}
variable "private_rtb_withoutnat" {
}
variable "private_rtb_db_name" {}

variable "elastic_ip" {}

variable "security_grp" {}

variable "INSTANCE_USERNAME" {}

variable "ec2-sg" {}

variable "instance_keypair_name_local" {}

variable "instance_keypair_name" {}

variable "instance_type" {}

variable "instance_public_name" {}

variable "instance_private_name" {}

variable "lb_name" {}

variable "s3_name" {}

variable "zone_id" {}

variable "dns_zone" {}

variable "dns_name" {}


variable "api" {}
variable "vpc-link" {}
variable "lb_dns" {}

# variable "nlb_arn" {}

variable "api_cert_domain" {}

variable "api_custom_domain" {}

# variable "db_username" {
#     sensitive = true
#     type=string
  
# }

# variable "db_password" {
#     sensitive = true
#     type=string
  
# }

variable "apicustdom" {
  
}
variable "stage-name" {}

//apigway_regional_domain_name
# variable "cloudfront_domainname" {
  
# }
//s3
# variable "domain_s3" {
#   default = "webappelevate"  
# }
# variable "sub_domain_s3" {
#   default = "webappelevate_net"  
# }



# variable "cidr_block_vpc2" {
#     default = "198.168.0.0/16"
  
# }
#type = map(string)