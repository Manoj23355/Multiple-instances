output "instance_public_ips" {
  description = "public ips of the created instances"
  value = aws_instance.instances[*].public_ip
}

