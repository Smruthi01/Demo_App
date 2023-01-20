output "bucketwt_id" {
    value = aws_s3_bucket.wt-angular-bucket.id
  
}

output "cloudfront_domainname" {
    value = aws_cloudfront_distribution.WT_webapp_distribution.domain_name
  
}

output "cloudfront_hostedzoneid" {
    value = aws_cloudfront_distribution.WT_webapp_distribution.hosted_zone_id
  
}

output "cloudfront_id" {
    value = aws_cloudfront_distribution.WT_webapp_distribution.id
  
}
output "cf_dns" {
    value = aws_cloudfront_distribution.WT_webapp_distribution.aliases
  
}