provider "github" {
  token = "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"
  owner = "Smruthi01"
}

resource "aws_s3_bucket" "wt-angular-bucket" {
  bucket = var.s3_name    
  tags = {
    "Name" = "demo-smru-architecture-bucket"
  }
}
resource "aws_s3_bucket_website_configuration" "wt-angular-bucket" {
  bucket = aws_s3_bucket.wt-angular-bucket.id 
    


  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
 

}

resource "aws_s3_bucket_cors_configuration" "s3_cors_policy" {
  bucket = aws_s3_bucket_website_configuration.wt-angular-bucket.id

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST","GET","DELETE"]
    allowed_origins = ["*"]
    expose_headers  = []
    //expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  
}



data "github_repository_file" "partylicenses" {
  provider   = github
  repository = "Webapp-FE"
  file       = "3rdpartylicenses.txt"
}

resource "aws_s3_object" "partylicenses" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "3rdpartylicenses.txt"
  content = data.github_repository_file.partylicenses.content
    content_type = "html"
}

data "github_repository_file" "favicon" {
  provider   = github
  repository = "Webapp-FE"
  file       = "favicon.ico"
}

resource "aws_s3_object" "favicon" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "favicon.ico"
  content = data.github_repository_file.favicon.content
   content_type = "html"
}

data "github_repository_file" "index" {
  provider   = github
  repository = "Webapp-FE"
  file       = "index.html"
}

resource "aws_s3_object" "index" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "index.html"
  content = data.github_repository_file.index.content
  content_type = "html"
}

data "github_repository_file" "main734dd9ec09d5279e" {
  provider   = github
  repository = "Webapp-FE"
  file       = "main.734dd9ec09d5279e.js" 
}

resource "aws_s3_object" "main734dd9ec09d5279e" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "main.734dd9ec09d5279e.js"
  content = data.github_repository_file.main734dd9ec09d5279e.content
    content_type = "html"
  //content = data.github_repository_file.main2618b292d1bef894.content
}

data "github_repository_file" "polyfillsec3d56949bbe7f12" {
  provider   = github
  repository = "Webapp-FE"
  file       = "polyfills.ec3d56949bbe7f12.js"
}

resource "aws_s3_object" "polyfillsec3d56949bbe7f12" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "polyfills.ec3d56949bbe7f12.js"
  content = data.github_repository_file.polyfillsec3d56949bbe7f12.content
    content_type = "html"
}

data "github_repository_file" "runtime522b5558c50cfe9d" {
  provider   = github
  repository = "Webapp-FE"
  file       = "runtime.522b5558c50cfe9d.js"
}

resource "aws_s3_object" "runtime522b5558c50cfe9d" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "runtime.522b5558c50cfe9d.js"
  content = data.github_repository_file.runtime522b5558c50cfe9d.content
    content_type = "html"
}

data "github_repository_file" "styles3b3721e0d09786ee" {
  provider   = github
  repository = "Webapp-FE"
  file       = "styles.3b3721e0d09786ee.css"
}

resource "aws_s3_object" "styles3b3721e0d09786ee" {
  bucket  = aws_s3_bucket.wt-angular-bucket.id
  key     = "styles.3b3721e0d09786ee.css"
  content = data.github_repository_file.styles3b3721e0d09786ee.content
    content_type = "html"
}

#  cloudfront 

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "wt-angular-bucket"
}
locals {
   s3_origin_id = aws_s3_bucket.wt-angular-bucket.bucket_domain_name

}

data "aws_iam_policy_document" "s3_cf_policy" {
  statement {

    actions   = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.wt-angular-bucket.arn}/*"]

    principals {
      type        = "AWS"
      //identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cdn-cf-policy" {
  bucket = aws_s3_bucket.wt-angular-bucket.id
  policy = data.aws_iam_policy_document.s3_cf_policy.json
}


resource "aws_cloudfront_distribution" "WT_webapp_distribution" {
  origin {
    domain_name = aws_s3_bucket.wt-angular-bucket.bucket_regional_domain_name
     origin_id  = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      
    }
  }

  aliases = ["smru-wt-webapp-lt.devops.coda.run"]

   enabled            = true
  is_ipv6_enabled     = true
  comment             = "current-cloudfront"
  default_root_object = "index.html"

default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
    #   headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 600
    max_ttl                = 86400
    
  }

    viewer_certificate {
    // ssl_support_method = "sni-only"
   // acm_certificate_arn =var.acm_cert_arn
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = [ ]
    }
  }
  
    tags = {   
    Name        = "Demo_WT_webapp_distribution"
  }

  depends_on = [
    var.acm_cert_id
  ]

}
 
 output "cf-wt-distru" {
    value = aws_cloudfront_distribution.WT_webapp_distribution.id
  
}
