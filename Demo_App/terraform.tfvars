AWS_REGION= "us-east-1"
AMIS="ami-0b0dcb5067f052a63"
cidr_block_vpc = "10.0.0.0/18" 
vpc_name = "DemoSmruWebapp"

pub_subnet_name = "WT_pub_sub1"
pub_subnet2_name="WT_pub_sub2"

private_subnet1_name="WT_prv_sub1"
private_subnet2_name="WT_prv_sub2"
private_subnet3_name="WT_prv_sub3"
private_subnet4_name="WT_prv_sub4"
private_subnet5_name="WT_prv_sub5"

alltraffic_cidr="0.0.0.0/0"
cidr_block_pubsub="10.0.0.0/21"  //2046 ips
cidr_block_pubsub2 = "10.0.8.0/21" 
cidr_block_pvtsub1="10.0.16.0/22" //1022 ips
cidr_block_pvtsub2 = "10.0.20.0/22"
cidr_block_pvtsub3 ="10.0.24.0/22"
cidr_block_pvtsub4="10.0.28.0/22"
cidr_block_pvtsub5="10.0.32.0/22"

az-1= "us-east-1a"
az-2= "us-east-1b"  
az-3="us-east-1c"

public_rtb_name="WT_pubrtb"
private_rtb_name="WT_prvrtb"
private_rtb_db_name="WT_pvtrtb_db"
private_rtb_withoutnat="WT_pvtrtb_without_nat"
security_grp="demo_WT_securitygrp"
elastic_ip="demo_WT_elastic_ip"
igw_name="demo_smru_WT_igw"
nat_name="demo_smru_WT_nat"

INSTANCE_USERNAME="user"  
instance_keypair_name_local="demo_WT_smru_keypair_local.pem"
instance_keypair_name="demo_WT_smru_keypair.pem"
instance_type="t2.micro"
instance_public_name="WT_ec2_pub"
instance_private_name="demo-WT_ec2_priv"
ec2-sg = "demo-wt-sg-ec2-priv"

s3_name="demo-smru-architecture-bucket"

lb_name="demo_smru_WT_lb"

zone_id = "Z10334291PDXVB5K3ZJ2G"
dns_zone="devops.coda.run"
dns_name="demo-smru-wt-webapp-lt"
# dns_record_name="wt-webapp-lt"
api = "demo-wt-rest-api"
api_cert_domain="demo-wt_webapp_api_acm01"
api_custom_domain="demoapi"

stage-name = "demostage1"

lb_dns="demo-nlb"
vpc-link = "demo-wt-vpc-link"

//nlb_arn = "arn:aws:elasticloadbalancing:us-east-1:853973692277:loadbalancer/net/smru-nlb-webapp/3b1e0352c8d5db7f"

apicustdom="demoapicustom.smru-wt-webapp-lt.devops.coda.run"
//subnet calculation
# vpc = "192.168.0.0/18"

# 2^14 => 16382 ips 

# 25% of ips => public subnet => 4095 ips (2*2046)
# 75?% of ips => private subnet => 12286 ips (6*2046)

