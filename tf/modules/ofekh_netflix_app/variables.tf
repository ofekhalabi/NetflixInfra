variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-west-2"
}

variable "availability_zone" {
    description = "The availability zone for the subnet"
    type        = list(string)
    default     = "us-west-2a,us-west-2b,us-west-2c"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
    description = "The CIDR block for the subnet"
    type        = list(string)
    default     = ["10.0.0.0/24", "10.0.1.24/24"]
}

variable "public_subnet_cidr" {
    description = "The CIDR block for the subnet"
    type        = list(string)
    default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "amd_id" {
    description = "EC2 Ubuntu AMI"
    type        = string
    default     = "ami-091f18e98bc129c4e"
}

variable "instance_type" {
    description = "The type of instance"
    type        = string
    default     = "t3.medium"
}

variable "key_name" {
    description = "The name of the key pair"
    type        = string
    default     = "ofekh-tf-key"
}

variable "public_key_path" {
    description = "The path to the public key"
    type        = string
    default     = "C:/Users/shayh/.ssh/ofekh-tf-key.pub" # Path to your public key
}

variable "bucket_name" {
    description = "The name of the S3 bucket"
    type        = string
    default     = "ofekh-netflix-bucket"
}

variable "env" {
    description = "The environment"
    type        = string
    default     = "dev"
}

variable "security_group_name" {
    description = "The name of the security group"
    type        = string
    default     = "ofekh-netflix-app-sg"
}

variable "instance_name" {
    description = "The name of the instance"
    type        = string
    default     = "ofekh-tf-netflix"
}