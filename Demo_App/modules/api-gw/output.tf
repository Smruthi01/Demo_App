output "apigway_regional_domain_name" {
    value =  aws_api_gateway_domain_name.wt-api-domain.regional_domain_name 
  
}
output "apigw_domain_regional_zone_id" {
    value =  aws_api_gateway_domain_name.wt-api-domain.regional_zone_id
  
}
output "custom_apigw_id" {
    value = aws_api_gateway_domain_name.wt-api-domain.id

}
# output "custom_api_domainname" {
#     value = 
  
