
resource "aws_vpc" "Webapp_vpc" {
    cidr_block = var.cidr_block_vpc
    tags = {
      "Name" = var.vpc_name
    }     
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pubsub
    availability_zone = var.az-1
  tags = {
    "Name" = var.pub_subnet_name
  }
}
resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.Webapp_vpc.id
    
    cidr_block = var.cidr_block_pubsub2
    availability_zone = var.az-2
  tags = {
    "Name" = var.pub_subnet2_name
  }
}

resource "aws_subnet" "private_subnet1" {

    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pvtsub1
    availability_zone = var.az-1
    tags = {
      "Name" = var.private_subnet1_name
    }
  
}


resource "aws_subnet" "private_subnet2" {

    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pvtsub2
    availability_zone = var.az-2
    tags = {
      "Name" =var.private_subnet2_name
    }
  
}


resource "aws_subnet" "private_subnet3" {

    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pvtsub3
    availability_zone = var.az-3
    tags = {
      "Name" = var.private_subnet3_name
    }
  
}


resource "aws_subnet" "private_subnet4_db" {

    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pvtsub4
    availability_zone = var.az-3
    tags = {
      "Name" = var.private_subnet4_name
    }
  
}


resource "aws_subnet" "private_subnet5_db" {

    vpc_id = aws_vpc.Webapp_vpc.id
    cidr_block = var.cidr_block_pvtsub5
    availability_zone = var.az-1
    tags = {
      "Name" = var.private_subnet5_name
    }
  
}
resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.Webapp_vpc.id
    tags={
        "Name" = var.igw_name
    }
  
}


resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.Webapp_vpc.id

      route {
    cidr_block = var.alltraffic_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

   tags={
        "Name" = var.public_rtb_name
    }
  
    }

resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "associate_pub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rtb.id
}


resource "aws_eip" "elastic_ip" {
  vpc      = true
  tags = {
    Name = var.elastic_ip
  }
}

resource "aws_nat_gateway" "s-nat" {

    allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_name
  }
  
}

resource "aws_route_table" "private_rtb" {
   vpc_id = aws_vpc.Webapp_vpc.id


  route {
    cidr_block = var.alltraffic_cidr
    gateway_id = aws_nat_gateway.s-nat.id
  }
   tags = {
    Name = var.private_rtb_name
  }

  
}


resource "aws_route_table" "private_rtb_withoutnat" {
    vpc_id = aws_vpc.Webapp_vpc.id

   tags = {
    Name = var.private_rtb_db_name
  }
  
}

resource "aws_route_table_association" "pvt-associate" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rtb.id
}
resource "aws_route_table_association" "pvt3-associate" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "pvt4-associate" {
  subnet_id      = aws_subnet.private_subnet4_db.id
  route_table_id = aws_route_table.private_rtb_withoutnat.id
}

resource "aws_route_table_association" "pvt5-associate" {
  subnet_id      = aws_subnet.private_subnet5_db.id
  route_table_id = aws_route_table.private_rtb_withoutnat.id
}


resource "aws_security_group" "default_sg" {
  vpc_id = aws_vpc.Webapp_vpc.id
  ingress {
    protocol    = "tcp"
  cidr_blocks = ["183.82.33.215/32"]
    from_port   = 22
    to_port     = 22
  }
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }
 
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = var.security_grp
  }
}



