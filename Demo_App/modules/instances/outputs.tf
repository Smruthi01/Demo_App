output "priv_instance" {
  value = aws_instance.web_instance_BE.id
}
output "priv_ec2_id" {
  value = aws_instance.web_instance_BE.id
}
output "ec2_sec_grp_id" {
  value = aws_security_group.wt-sg-ec2-priv.id
  
}