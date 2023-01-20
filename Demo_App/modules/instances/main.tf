provider "tls" {}

provider "local" {}

resource "tls_private_key" "t" {
    algorithm = "RSA"
}

resource "aws_key_pair" "keypairfile" {
    key_name   = var.instance_keypair_name
    public_key = tls_private_key.t.public_key_openssh
}


resource "local_file" "key" {
    content  = tls_private_key.t.private_key_pem
    filename = var.instance_keypair_name
          
}

resource "aws_security_group" "wt-sg-ec2-priv" {
  name = var.ec2-sg
  vpc_id = var.vpc_id
  //vpc_id = aws_vpc.Webapp_vpc.id

   ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }
  
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

    ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    to_port     = 3306
  }
}

resource "aws_instance" "web_instance_public" {
  
  ami           = var.AMIS
  instance_type = var.instance_type
  key_name=var.instance_keypair_name
  //key_name      = aws_key_pair.keypairfile.key_name
  subnet_id= var.pubsub1_id
  //subnet_id = aws_subnet.public_subnet.id
  
  vpc_security_group_ids = [var.default_sg_id]
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = tls_private_key.oskey.private_key_pem
    
   host        = aws_instance.web_instance_public.public_ip
    // host = self.public_ip
  }

   tags = {
    "Name" = var.instance_public_name
  }
}



resource "aws_instance" "web_instance_BE" {
  
  ami           =  var.AMIS
  instance_type = var.instance_type
  key_name      = aws_key_pair.keypairfile.key_name
  subnet_id = var.privsub1_id
  //subnet_id = aws_subnet.private_subnet1.id
  vpc_security_group_ids = [var.default_sg_id,aws_security_group.wt-sg-ec2-priv.id]

  user_data= file("userdata.sh")

   iam_instance_profile = var.dbsecret_instance_profile
   //"${aws_iam_instance_profile.test_instance_profile.name}"
 
  connection {
    host        = aws_instance.web_instance_BE.public_ip
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = tls_private_key.t.private_key_pem
   // host = self.public_ip
  }

    #  provisioner "remote-exec" {
    
    # inline = [
    # "sudo cd /home/ec2-user/Webapp-BE/",
    # "sudo mvn spring-boot:run"
    # ]
    #  }

  

  tags = {
    "Name" = var.instance_private_name
  }

  depends_on = [
    aws_key_pair.keypairfile,aws_security_group.wt-sg-ec2-priv
  ]


}


resource "aws_s3_object" "keypairfile" {

  //bucket = aws_s3_bucket.wt-angular-bucket.id
  bucket = var.bucketwt_id
  key    = "demo_WT_keypair.pem"

  acl    = "private"  

  source = "/Users/presidio/Desktop/terraform_aws/Demo_App/demo_WT_smru_keypair.pem"

  //etag = filemd5("/Users/presidio/Desktop/terraform_aws/Demo_App/demo-WT_keypair.pem") /Users/presidio/Desktop/terraform_aws/Demo_App/

  depends_on = [
    aws_instance.web_instance_BE
  ]

}



