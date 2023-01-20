//custom domain
resource "aws_api_gateway_domain_name" "wt-api-domain" {
  domain_name              = "${var.api_custom_domain}.${var.dns_name}.${var.dns_zone}"
  //"wt-webapp.devops.coda.run"
 regional_certificate_arn = var.acm_cert_arn
 //aws_acm_certificate.myapp.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

depends_on = [
 var.acm_cert_id
]

}


resource "aws_api_gateway_rest_api" "wt-api-rest" {
  name = var.api
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = {
    "Name"="demo-wt-api-rest"
  }
}




resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  parent_id   = aws_api_gateway_rest_api.wt-api-rest.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_method" "api-any" {
   rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
   resource_id = aws_api_gateway_resource.api.id
   http_method = "ANY"
   authorization    = "NONE"
  
}

resource "aws_api_gateway_method_response" "api-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.api.id
  http_method = aws_api_gateway_method.api-any.http_method
  status_code = "200"
}

resource "aws_api_gateway_usage_plan" "acme-api-gw-usage-plan" {
  name         = "${var.stage-name}-api"
  description  = " api usage plan"
  product_code = "wt-api"

#   api_stages {
#     api_id = aws_api_gateway_rest_api.wt-api-rest.id
#     stage  = aws_api_gateway_stage.api-gw-stage.id
#   }

  quota_settings {
    limit  = 10000
    offset = 1
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 100
    rate_limit  = 50
  }
}
resource "aws_api_gateway_api_key" "api-gw-default" {
  name = "${var.stage-name}-api"
}

resource "aws_api_gateway_usage_plan_key" "api-gw-default" {
  key_id        = aws_api_gateway_api_key.api-gw-default.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.acme-api-gw-usage-plan.id
}


//2
resource "aws_api_gateway_resource" "add" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "add"
}

resource "aws_api_gateway_method" "add-new" {
  rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id      = aws_api_gateway_resource.add.id
  http_method      = "POST"
  authorization    = "NONE"
  # api_key_required = true

#   request_parameters = {
#     "method.request.path.msg" = true
#   }
}

resource "aws_api_gateway_method_response" "addnew-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.add.id
  http_method = aws_api_gateway_method.add-new.http_method
  status_code = "200"


    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

//3
resource "aws_api_gateway_resource" "tutorials" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "tutorials"
}

resource "aws_api_gateway_method" "view-tutorial" {
  rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id      = aws_api_gateway_resource.tutorials.id
  http_method      = "GET"
  authorization    = "NONE"
  # api_key_required = true

#   request_parameters = {
#     "method.request.path.msg" = true
#   }
}
resource "aws_api_gateway_method" "add-tutorial" {
  rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id      = aws_api_gateway_resource.tutorials.id
  http_method      = "POST"
  authorization    = "NONE"
  # api_key_required = true

#   request_parameters = {
#     "method.request.path.msg" = true
#   }
}

resource "aws_api_gateway_method_response" "tutorials-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.tutorials.id
  http_method = aws_api_gateway_method.view-tutorial.http_method
  status_code = "200"

      response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_method_response" "addtutorials-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.tutorials.id
  http_method = aws_api_gateway_method.add-tutorial.http_method
  status_code = "200"

      response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}



//4
resource "aws_api_gateway_resource" "id" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  parent_id   = aws_api_gateway_resource.tutorials.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "id-tutorial" {
  rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id      = aws_api_gateway_resource.id.id
  http_method      = "PUT"
  authorization    = "NONE"
  # api_key_required = true

#   request_parameters = {
#     "method.request.path.msg" = true
#   }
}

resource "aws_api_gateway_method" "get-id-tutorial" {
  rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id      = aws_api_gateway_resource.id.id
  http_method      = "GET"
  authorization    = "NONE"
  # api_key_required = true

#   request_parameters = {
#     "method.request.path.msg" = true
#   }
}

resource "aws_api_gateway_method_response" "id-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id-tutorial.http_method
  status_code = "200"

      response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_method_response" "getid-msg-get-200" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.get-id-tutorial.http_method
  status_code = "200"

      response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}




# resource "aws_api_gateway_method" "get-all-tutorials" {
#   rest_api_id      = aws_api_gateway_rest_api.wt-api-rest.id
#   resource_id      = aws_api_gateway_resource.tutorials.id
#   http_method      = "ANY"
#   authorization    = "NONE"
#   # api_key_required = true

  
# }



resource "aws_api_gateway_integration" "api-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.api.id
  http_method             = aws_api_gateway_method.api-any.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "ANY"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }

depends_on = [
  aws_api_gateway_method.api-any,var.vpclink_id
]

}

resource "aws_api_gateway_integration_response" "api-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.api.id
  http_method = aws_api_gateway_method.api-any.http_method
  status_code = aws_api_gateway_method_response.api-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.api-integration
  ]

  #  response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #   # "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
  #   "method.response.header.Access-Control-Allow-Origin"      = "'*'",
  #   # "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  # }
}


resource "aws_api_gateway_integration" "addnew-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.add.id
  http_method             = aws_api_gateway_method.add-new.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "PUT"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api/add"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }

  depends_on = [
    aws_api_gateway_method.add-new,var.vpclink_id
  ]
}

resource "aws_api_gateway_integration_response" "addnew-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.add.id
  http_method = aws_api_gateway_method.add-new.http_method
  status_code = aws_api_gateway_method_response.addnew-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.addnew-integration
  ]

  #  response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #   "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
  #   "method.response.header.Access-Control-Allow-Origin"      = "'*'",
  #   "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  # }
}

resource "aws_api_gateway_integration" "tutorial-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.tutorials.id
  http_method             = aws_api_gateway_method.view-tutorial.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "ANY"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api/tutorials"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }
  depends_on = [
    aws_api_gateway_method.view-tutorial,var.vpclink_id
  ]
 
}

resource "aws_api_gateway_integration" "addtutorial-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.tutorials.id
  http_method             = aws_api_gateway_method.add-tutorial.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "ANY"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api/tutorials"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }
  depends_on = [
    aws_api_gateway_method.add-tutorial,var.vpclink_id
  ]
 
}

resource "aws_api_gateway_integration_response" "tutorial-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.tutorials.id
  http_method = aws_api_gateway_method.view-tutorial.http_method
  status_code = aws_api_gateway_method_response.tutorials-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.tutorial-integration
  ]

  #  response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #   "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
  #   "method.response.header.Access-Control-Allow-Origin"      = "'*'",
  #   "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  # }
}

resource "aws_api_gateway_integration_response" "addtutorial-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.tutorials.id
  http_method = aws_api_gateway_method.add-tutorial.http_method
  status_code = aws_api_gateway_method_response.tutorials-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.addtutorial-integration
  ]

  #  response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #   "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
  #   "method.response.header.Access-Control-Allow-Origin"      = "'*'",
  #   "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  # }
}


resource "aws_api_gateway_integration" "id-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.id.id
  http_method             = aws_api_gateway_method.id-tutorial.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "ANY"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api/tutorials/id"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }

depends_on = [
  aws_api_gateway_method.id-tutorial,var.vpclink_id
]
}

resource "aws_api_gateway_integration" "getid-integration" {
  rest_api_id             = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id             = aws_api_gateway_resource.id.id
  http_method             = aws_api_gateway_method.get-id-tutorial.http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_vpc_link
  integration_http_method = "ANY"
  type                    = "HTTP"
  uri                     = "https://${var.lb_dns}.${var.dns_name}.${var.dns_zone}/api/tutorials/id"
#   request_parameters = {
#     "integration.request.path.msg" = "method.request.path.msg"
#   }

depends_on = [
  aws_api_gateway_method.api-any,var.vpclink_id
]
}

resource "aws_api_gateway_integration_response" "id-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id-tutorial.http_method
  status_code = aws_api_gateway_method_response.id-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.id-integration
  ]

  #  response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #   "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
  #   "method.response.header.Access-Control-Allow-Origin"      = "'*'",
  #   "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  # }
}

resource "aws_api_gateway_integration_response" "getid-integ-res" {
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.get-id-tutorial.http_method
  status_code = aws_api_gateway_method_response.id-msg-get-200.status_code

  depends_on = [
    aws_api_gateway_integration.id-integration
  ]

#    response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin"      = "'*'",
#     "method.response.header.Access-Control-Allow-Credentials" = "'true'"
#   }
}


resource "aws_api_gateway_deployment" "api-deploy" {
  
  rest_api_id = aws_api_gateway_rest_api.wt-api-rest.id

  triggers = {
    redeployment = sha1(jsonencode([
        aws_api_gateway_resource.api.id,     
        aws_api_gateway_method.api-any.id,
        aws_api_gateway_method_response.api-msg-get-200.id,
        aws_api_gateway_integration.api-integration.id,
         aws_api_gateway_resource.add.id,
         aws_api_gateway_method.add-new.id,
         aws_api_gateway_integration.api-integration.id,
         aws_api_gateway_method_response.addnew-msg-get-200.id,
         aws_api_gateway_resource.tutorials.id,
         aws_api_gateway_method.view-tutorial.id,
         aws_api_gateway_method.add-tutorial.id,
         aws_api_gateway_integration.tutorial-integration.id,
         aws_api_gateway_integration.addtutorial-integration.id,
         aws_api_gateway_method_response.tutorials-msg-get-200.id,
         aws_api_gateway_method_response.addtutorials-msg-get-200.id,
         aws_api_gateway_resource.id,
         aws_api_gateway_method.id-tutorial,
         aws_api_gateway_method.get-id-tutorial,
         aws_api_gateway_method_response.id-msg-get-200,
          aws_api_gateway_method_response.getid-msg-get-200,
          aws_api_gateway_integration.id-integration,
           aws_api_gateway_integration.getid-integration



    ]))
  }

      depends_on = [
       aws_api_gateway_resource.api,aws_api_gateway_resource.add,aws_api_gateway_resource.tutorials, aws_api_gateway_resource.id
      ]
   lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "api-gw-stage" {
  deployment_id = aws_api_gateway_deployment.api-deploy.id
  rest_api_id   = aws_api_gateway_rest_api.wt-api-rest.id
  stage_name    = var.stage-name

  depends_on = [
    aws_api_gateway_deployment.api-deploy
  ]
}


resource "aws_api_gateway_base_path_mapping" "acme-api-gw-domain-mapping" {
  api_id      = aws_api_gateway_rest_api.wt-api-rest.id
  stage_name  = aws_api_gateway_stage.api-gw-stage.stage_name
  domain_name = aws_api_gateway_domain_name.wt-api-domain.domain_name
}


# resource "aws_api_gateway_base_path_mapping" "acme-api-gw-domain-mapping" {
#   api_id      = aws_api_gateway_rest_api.wt-api-rest.id
#   stage_name  = aws_api_gateway_stage.api-gw-stage.stage_name
#   domain_name = aws_api_gateway_domain_name.wt-api-domain.domain_name
# }


#    aws_api_gateway_resource.add.id,
#         aws_api_gateway_resource.tutorials.id,
#         aws_api_gateway_resource.id.id,
        # aws_api_gateway_method.add-new.id,
