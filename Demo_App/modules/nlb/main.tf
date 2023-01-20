resource "aws_lb" "WT_nlb" {
  name               = "demo-smru-nlb-webapp"
  internal           = true
  load_balancer_type = "network"
  subnets            = [ var.privsub1_id,var.privsub2_id ]

  # enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


resource "aws_lb_target_group" "wt-nlb-target-group" {
  name = "demo-smru-wt-nlb-target-group"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id
  proxy_protocol_v2 = false
 
  health_check {
    protocol="HTTP"
    path = "/api/"
    port = 8080
    healthy_threshold = 3
    interval = 30
    enabled = true
    timeout = 10
    unhealthy_threshold = 2
    //sucesscode
    
  }
  tags = {
    "Name" = "demo-wt-nlb-target-group"
  }

  depends_on = [
    aws_lb.WT_nlb,var.priv_ec2_id
  ]
  
}

resource "aws_lb_target_group_attachment" "tg-attachment" {

  target_group_arn = aws_lb_target_group.wt-nlb-target-group.arn
  target_id        = var.priv_instance
    port             = 8080
}




resource "aws_lb_listener" "wt-nlb-listener" {
  load_balancer_arn = aws_lb.WT_nlb.arn
  port              = "443"
  protocol          = "TLS" 
  certificate_arn   = var.acm_cert_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wt-nlb-target-group.arn
  }
  tags = {
    "Name" = "demo-smru-listener"
  }

  depends_on = [
    aws_lb.WT_nlb
  ]
}
//needed
resource "aws_api_gateway_vpc_link" "wt-vpc-link" {
  name        = var.vpc-link
  target_arns = [ "${aws_lb.WT_nlb.arn}" ]
  //[var.nlb_arn]

   tags = {
    "Name"="demo-wt-vpc-link" 
  }
  depends_on = [
    aws_lb.WT_nlb
  ]
}

resource "aws_security_group" "nlb_security" {
  description = "connection between NLB and target"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
 // for_each = var.ports

  security_group_id = aws_security_group.nlb_security.id
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# resource "aws_api_gateway_base_path_mapping" "acme-api-gw-domain-mapping" {
#   api_id      = aws_api_gateway_rest_api.wt-api-rest.id
#   stage_name  = aws_api_gateway_stage.api-gw-stage.stage_name
#   domain_name = aws_api_gateway_domain_name.wt-api-domain.domain_name
# }



# resource "aws_acm_certificate" "api-acm-cert" {
#   domain_name               = aws_route53_record.wt-acm-api-gw-domain.fqdn
#   validation_method         = "DNS"
# #  // subject_alternative_names = ["${var.env-name}-acme-gw.${var.region-name}.${var.domain}"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }


# resource "aws_route53_record" "api_cert_record" {
#   allow_overwrite = true
#   # name = "tobemodi"
#   # type    = "A"
#   #  records = [aws_instance.web_instance_public.public_ip]
#   name            = tolist(aws_acm_certificate.api-acm-cert.domain_validation_options)[0].resource_record_name
#    records         = [ tolist(aws_acm_certificate.api-acm-cert.domain_validation_options)[0].resource_record_value ]
#   type            = tolist(aws_acm_certificate.api-acm-cert.domain_validation_options)[0].resource_record_type
#   zone_id  = data.aws_route53_zone.public.id
#   ttl      = 60

# }

# resource "aws_acm_certificate_validation" "api-cert" {
#   certificate_arn         = aws_acm_certificate.api-acm-cert.arn
#   validation_record_fqdns = [ aws_route53_record.api_cert_record.fqdn ]
# }




# resource "aws_route53_record" "wt-acm-api-gw-domain" {

#   name    =  "${var.api_custom_domain}.${data.aws_route53_zone.public.name}"
#   type    = "CNAME"
#   zone_id =  data.aws_route53_zone.public.id
#   # ttl      = 60
#    records = [aws_instance.web_instance_public.public_ip]

#   # alias {
#   #   evaluate_target_health = true
#   #   name                   = aws_api_gateway_domain_name.wt-api-domain.regional_domain_name
#   #   zone_id                = aws_api_gateway_domain_name.wt-api-domain.regional_zone_id
#   # }
# }

// webappeleavate.devops.coda.run 
 // *.webappelevate.dev











# resource "aws_api_gateway_integration_response" "acme-api-gw-rs-acme-common-echo-msg-get-integration-response" {
#   rest_api_id = aws_api_gateway_rest_api.acme-api-gw-rest.id
#   resource_id = aws_api_gateway_resource.acme-api-gw-rs-acme-common-echo-msg.id
#   http_method = aws_api_gateway_method.acme-api-gw-rs-acme-common-echo-msg-get.http_method
#   status_code = aws_api_gateway_method_response.acme-api-gw-rs-acme-common-echo-msg-get-200.status_code
# }



//resource "aws_lb_listener_certificate" "example" {
#   listener_arn    = aws_lb_listener.wt-nlb-listener.arn
#   certificate_arn = aws_acm_certificate.myapp.arn
# }

