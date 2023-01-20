output "vpc_id" {
  value=aws_vpc.Webapp_vpc.id
}

output "pubsub_id" {
    value = aws_subnet.public_subnet.id
  
}
output "pubsub2_id" {
    value = aws_subnet.public_subnet2.id
  
}
output "privsub1_id" {
    value = aws_subnet.private_subnet1.id
  
}
output "privsub2_id" {
    value = aws_subnet.private_subnet2.id
  
}
output "privsub3_id" {
    value = aws_subnet.private_subnet3.id
  
}


output "privsub4_id" {
    value = aws_subnet.private_subnet4_db.id  
}

output "privsub5_id" {
    value = aws_subnet.private_subnet5_db.id
  
}

output "igw" {
    value = aws_internet_gateway.igw.id
  
}

output "default_sg_id" {
    value = aws_security_group.default_sg.id
  
}
