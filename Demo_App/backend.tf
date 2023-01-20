
 terraform {
  backend "s3" {
 
     bucket = "smru-webapp-backend"
  //bucket = "terraform-running-state"
  # key    = "webapp/terraform.tfstate"
    region = "us-east-1"
    key            = "global/demo/demo-terraform.tfstate" //change key
   
  //dynamodb_table = "terraform-running-locks"
    dynamodb_table = "smru-terraform-running-locks"
    encrypt        = true
  }
}