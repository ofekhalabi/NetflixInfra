terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region = var.region
  #  profile = "default"  # change in case you want to work with another AWS account profile
}



#create a new instance
resource "aws_instance" "netflix_app" {
  ami             = var.ami_id
  instance_type   = "t3.medium"
  vpc_security_group_ids = [aws_security_group.netflix_app_sg.id]
  key_name        = aws_key_pair.tf_key_ec2.key_name
  subnet_id       = module.netflix_app_vpc.public_subnets[0]

  tags = {
    Name      = "ofekh-tf-netflix-${var.env}"
    terraform = "owner"
    Env       = var.env
  }

  depends_on = [
    aws_s3_bucket.tf_s3_bucket # the instance will be created only after the s3 bucket is created
  ]
}

#create a new security group
resource "aws_security_group" "netflix_app_sg" {
  name        = "ofekh-netflix-app-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = module.netflix_app_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#create a new key pair
resource "aws_key_pair" "tf_key_ec2" {
  key_name   = "ofekh-tf-key"
  public_key = file("C:/Users/shayh/.ssh/ofekh-tf-key.pub") # Path to your public key
}


#create a s3 bucket
resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "ofekh-tf-netflix-${var.region}-${var.env}"
  acl    = "private" #only the owner can access the bucket
  tags = {
    Name = "ofekh-tf-netflix"
  }
}


terraform {

  backend "s3" {
    bucket = "ofekh-netflix-infra-tfs"
    key    = "tfstate.json"
    region = "eu-north-1"
    # optional: dynamodb_table = "<table-name>"
  }

}
module "netflix_app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "ofekh-netflix-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.vpc_azs
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]

  map_public_ip_on_launch = true

  enable_nat_gateway = false

  tags = {
    Env         = var.env
    Created_By  = "terraform"
  }
}