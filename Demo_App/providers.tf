provider "aws"{

    region = "us-east-1"
    profile = "default"
  
}



provider "tls" {}

provider "local" {}

provider "github" {
  token = "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"
  owner = "Smruthi01"
}

# provider "aws" {
#   alias = "acm"
#   region = "us-east-1"
#   # version = "2.24"
# }
