output "web_servers" {
  value = aws_instance.web_servers
}

output "security_group_id" {
  value = aws_security_group.web.id
}
