# AWS Region - REPLACE WITH YOUR REGION
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"  # REPLACE WITH YOUR DESIRED REGION (e.g., ap-south-1, eu-west-1)
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet CIDR
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

# Root Volume Size
variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

# AMI ID - Ubuntu 22.04 LTS (REPLACE WITH AMI ID FOR YOUR REGION)
variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # REPLACE WITH UBUNTU 22.04 AMI ID FOR YOUR REGION
  # Find your region's AMI: https://cloud-images.ubuntu.com/locator/ec2/
  # Example: us-east-1: ami-0c55b159cbfafe1f0
}

# Key Pair Name
variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instances"
  type        = string
  default     = "devops-key"  # REPLACE WITH YOUR KEY PAIR NAME
}

# Public Key - REPLACE WITH YOUR PUBLIC KEY
variable "public_key" {
  description = "Public SSH key for EC2 instance access"
  type        = string
  default     = ""  # REPLACE WITH YOUR PUBLIC KEY (e.g., from ~/.ssh/id_rsa.pub)
  sensitive   = true
}

# Allowed SSH CIDR - REPLACE WITH YOUR IP
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"  # REPLACE WITH YOUR IP (e.g., 203.0.113.0/32 for your IP)
  # For security, use your specific IP instead of 0.0.0.0/0
}

# CloudWatch Log Group Name
variable "log_group_name" {
  description = "Name of CloudWatch log group"
  type        = string
  default     = "react-app-logs"
}

# Log Retention Period in days
variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 7
}
