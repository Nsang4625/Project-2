resource "aws_security_group" "databases" {
  name   = "databases"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_traffic" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.databases.id
  source_security_group_id = var.web_security_group_id
}


resource "aws_db_subnet_group" "main" {
  name       = "subnet-group-for-rds"
  subnet_ids = [var.first_rds_subnet_id, var.second_rds_subnet_id]
  tags = {
    Name = "Subnet group for rds"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16.1"
  instance_class         = "db.m5d.large"
  identifier             = "main"
  username               = "root"
  password               = "postgres123"
  vpc_security_group_ids = [aws_security_group.databases.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  db_name                = "reserveren"
}
