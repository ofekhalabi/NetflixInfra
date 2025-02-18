variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "EC2 Ubuntu AMI"
  type        = string
}
