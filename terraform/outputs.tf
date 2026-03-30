# Output values from Terraform
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.devops_eip.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.devops_instance.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.devops_sg.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.devops_vpc.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i /path/to/private/key.pem ubuntu@${aws_eip.devops_eip.public_ip}"
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app_logs.name
}

output "jenkins_url" {
  description = "Jenkins URL (after setup)"
  value       = "http://${aws_eip.devops_eip.public_ip}:8080"
}

output "app_url" {
  description = "React app URL"
  value       = "http://${aws_eip.devops_eip.public_ip}:3000"
}
