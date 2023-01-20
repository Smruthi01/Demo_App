output "api_vpc_link" {
    value = aws_api_gateway_vpc_link.wt-vpc-link.id
  
}
output "WT_nlb_dns_name" {
    value = aws_lb.WT_nlb.dns_name
  
}

output "nlb_arn" {
    value = aws_lb.WT_nlb.arn
  
}
output "vpclink_id" {
    value = aws_api_gateway_vpc_link.wt-vpc-link.id
  
}
output "nlb_id" {
    value = aws_lb.WT_nlb.id
  
}