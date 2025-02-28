#create a new instance
resource "aws_instance" "netflix_app" {
  count           = 2 # create 2 instances
  ami             = var.amd_id
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.netflix_app_sg.id]
  key_name        = var.key_name
  subnet_id       = module.netflix_app_vpc.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.netflix_app_profile.name


  tags = {
    Name      = "${var.instance_name}-${var.env}"
    terraform = "owner"
    Env       = var.env
  }

  depends_on = [
    aws_s3_bucket.netflix_s3_bucket # the instance will be created only after the s3 bucket is created
    aws_iam_instance_profile.netflix_app_profile # the instance will be created only after the instance profile is created
    aws_key_pair.tf_key_ec2 # the instance will be created only after the key pair is created
  ]
}

#create a new key pair
resource "aws_key_pair" "tf_key_ec2" {
  key_name   = var.key_name
  public_key = file(var.public_key_path) # Path to your public key
}

module "netflix_app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "ofekh-netflix-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zone
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  map_public_ip_on_launch = true

  enable_nat_gateway = false

  tags = {
    Env         = var.env
    Created_By  = "terraform"
  }
}

#create a new security group
resource "aws_security_group" "netflix_app_sg" {
  name        = var.security_group_name
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

resource "aws_iam_role" "netflix_app_role" {
  name = "tf_netflix_app_role"
  assume_role_policy = jsonencode({  # This defines who can assume the role
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # This allows EC2 instances to assume the role
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "ebs" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sns" {
  role       = aws_iam_role.netflix_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}


resource "aws_iam_instance_profile" "netflix_app_profile" {
  name = "tf_netflix_app_profile"
  role = aws_iam_role.netflix_app_role.name
}

#create a s3 bucket
resource "aws_s3_bucket" "netflix_s3_bucket" {
  bucket = "${var.bucket_name}-${var.region}-${var.env}"
  acl    = "private" #only the owner can access the bucket
  tags = {
    Name = var.bucket_name
  }
}