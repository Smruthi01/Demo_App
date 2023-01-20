
data "aws_route53_zone" "public" {
  name         = var.dns_zone
  private_zone = false
 
}


resource "aws_acm_certificate" "myapp" {
  domain_name       = aws_route53_record.myapp.fqdn
  subject_alternative_names = ["*.${aws_route53_record.myapp.fqdn}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

} 



resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_name
  records         = [ tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_value ]
  type            = tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_type
  zone_id  = data.aws_route53_zone.public.id
  ttl      = 60

depends_on = [
  aws_acm_certificate.myapp
]
}

resource "aws_route53_record" "nlb-dns-mapping" {
  allow_overwrite = true
  name = "${var.lb_dns}.${var.dns_name}.${var.dns_zone}"
  records = ["${var.WT_nlb_dns_name}"]
  type = "CNAME"
  zone_id  = data.aws_route53_zone.public.id
  ttl      = 60

  # depends_on = [
  #   var. nlb_id
  # ]
  
}


resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.myapp.arn
  validation_record_fqdns = [ aws_route53_record.cert_validation.fqdn ]
}


resource "aws_route53_record" "myapp" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.dns_name}.${data.aws_route53_zone.public.name}"
  type    = "A"  
  records = ["${var.cf_dns}"] 
  ttl = 60


  #  alias {
  #   name=var.cloudfront_domainname
  #   zone_id = var.cloudfront_hostedzoneid
  #    //name = aws_cloudfront_distribution.WT_webapp_distribution.domain_name
  #    //zone_id = aws_cloudfront_distribution.WT_webapp_distribution.hosted_zone_id
  #    evaluate_target_health = true
  #  }
   //aadding api gw to route53
  # alias {
  #   evaluate_target_health = true
  #   name                   = var.apigway_regional_domain_name
  #   //aws_api_gateway_domain_name.wt-api-domain.regional_domain_name 
  #  zone_id              = var.apigw_domain_regional_zone_id
  #   //  = aws_api_gateway_domain_name.wt-api-domain.regional_zone_id
  # }
  //check

  # depends_on = [
  #   # var.custom_apigw_id
  #   var.cloudfront_id
  # ]

}


resource "aws_route53_record" "api-dns-mapping" {
  allow_overwrite = true

  name = "${var.api_custom_domain}.${var.dns_name}.${var.dns_zone}"
  records = ["${var.apigway_regional_domain_name}"]
  type = "CNAME"
  zone_id  = data.aws_route53_zone.public.id
   ttl      = 60
 
depends_on = [
  var.custom_apigw_id
]
  
}

# resource "aws_route53_record" "myapp_customapi" {
#   zone_id = data.aws_route53_zone.public.zone_id
#   name    = "${var.apicustdom}.${var.dns_name}.${data.aws_route53_zone.public.name}"
#   type    = "CNAME"
#   records = [var.apigw_domain_regional_zone_id]

  #   alias {
  #   evaluate_target_health = true
  #   name                   = var.apigway_regional_domain_name
 
  #  zone_id              = var.apigw_domain_regional_zone_id
 
  # }

#   depends_on = [
#     var.custom_apigw_id

#   ]
# }
   //  = aws_api_gateway_domain_name.wt-api-domain.regional_zone_id
       //aws_api_gateway_domain_name.wt-api-domain.regional_domain_name

output "testing" {
  value = " https://${aws_route53_record.myapp.fqdn} "
}

 

 
  # records = ["d2alzvhtyozcv5.cloudfront.net"]

  //records        = aws_cloudfront_distribution.WT_webapp_distribution.domain_name
//["d2alzvhtyozcv5.cloudfront.net"]


#   alias {
#     name                   = aws_lb.WT_nlb.dns_name
#     zone_id                = aws_lb.WT_nlb.zone_id
#     evaluate_target_health = false
#   }