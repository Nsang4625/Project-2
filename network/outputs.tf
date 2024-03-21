output "vpc_id" {
  value = aws_vpc.main.id
}

output "first_public_subnet_id" {
  value = aws_subnet.first_public.id
}

output "second_public_subnet_id" {
  value = aws_subnet.second_public.id
}

output "first_private_web_subnet_id" {
  value = aws_subnet.first_private_web.id
}

output "second_private_web_subnet_id" {
  value = aws_subnet.second_private_web.id
}

output "first_private_rds_subnet_id" {
  value = aws_subnet.first_private_rds.id
}

output "second_private_rds_subnet_id" {
  value = aws_subnet.second_private_rds.id
}
