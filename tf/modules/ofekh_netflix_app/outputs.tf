output "public_ip_netflix_app" {
  description = "The public IP of the Netflix app instance"
  value       = aws_instance.netflix_app.public_ip
}

output "instance_id_netflix_app {
  description = "The instance ID of the Netflix app instance"
  value       = aws_instance.netflix_app.id
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = var.bucket_name
}