output "public_ip_netflix_app_instance" {
  description = "The public IP of the Netflix app instance"
  value       = aws_instance.netflix_app.public_ip
}