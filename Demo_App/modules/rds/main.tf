resource "aws_security_group" "rds" {
  name        = "wt_rds_security_group"
  description = "RDS MySQL server"

  vpc_id = var.vpc_id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
   // cidr_blocks = [var.priv_ec2_id,var.ec2_sec_grp_id]
    security_groups = [var.ec2_sec_grp_id]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name = "demo-terraform-rds-security-group"
   }
  

  
}




resource "aws_db_subnet_group" "wt-rds-group" {
  name        = "demo-smru-wt-rds-subnet"
  description = "Demo Terraform  RDS subnet group"
  subnet_ids  = [var.privsub4_id,var.privsub5_id]
}

resource "aws_db_instance" "smru-wt-mysql-rds" {
  allocated_storage    = 10
   max_allocated_storage = 100
  db_name              = "testdb"
  identifier = "demo-smru-wt-mysql-rds"
  engine               = "mysql"
  engine_version       = "8.0.28"
  
  instance_class       = "db.t2.micro"
  availability_zone = var.az-1
  username             =  local.db_creds.username     //"root"
  password             =   local.db_creds.password   //"PASSWORD"
  parameter_group_name = "default.mysql8.0"   
  skip_final_snapshot  = true
  db_subnet_group_name      = aws_db_subnet_group.wt-rds-group.id
  vpc_security_group_ids    = [aws_security_group.rds.id]
  tags = {
    "name" = "demo-wt-mysql-rds"
  }
 depends_on = [
   aws_security_group.rds, aws_db_subnet_group.wt-rds-group,aws_secretsmanager_secret.db_secret,aws_secretsmanager_secret_version.creds,random_password.password
 ]
}

resource "aws_db_parameter_group" "smru-db-param" {
  name        = "demo-smru-rds-param-group"
  family      = "mysql5.6"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

//secret manager
resource "aws_secretsmanager_secret" "db_secret" {
  name = "smru_db_secret"

}

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = <<EOF
   {
    "username": "root",
    "password": "${random_password.password.result}"
   }
EOF
}

//"${random_password.password.result}"
resource "aws_iam_role" "secret_iam_role" {
  name = "secret_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "test"
  }
}

resource "aws_iam_role_policy" "secret_secretmanager_policy" {
  name = "secret_secretmanager_policy"
  role = "${aws_iam_role.secret_iam_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "${aws_secretsmanager_secret.db_secret.arn}" 
    }]
}
EOF
}

resource "aws_iam_instance_profile" "secret_instance_profile" {
  name = "test_instance_profile"
  role = "${aws_iam_role.secret_iam_role.name}"
}

data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.db_secret.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}