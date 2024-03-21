resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "first_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.first_public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
}
resource "aws_subnet" "second_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.second_public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "associate_first_public" {
  subnet_id      = aws_subnet.first_public.id
  route_table_id = aws_route_table.public_subnet.id
}
resource "aws_route_table_association" "associate_second_public" {
  subnet_id      = aws_subnet.second_public.id
  route_table_id = aws_route_table.public_subnet.id
}


resource "aws_subnet" "first_private_web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.first_private_subnet_web_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_subnet" "second_private_web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.second_private_subnet_web_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
}
resource "aws_eip" "first_nat_gateway" {
  associate_with_private_ip = "10.0.1.5"
}
resource "aws_eip" "second_nat_gateway" {
  associate_with_private_ip = "10.0.4.5"
}
resource "aws_nat_gateway" "first" {
  allocation_id = aws_eip.first_nat_gateway.id
  subnet_id     = aws_subnet.first_public.id
  depends_on    = [aws_internet_gateway.main]
}
resource "aws_nat_gateway" "second" {
  allocation_id = aws_eip.second_nat_gateway.id
  subnet_id     = aws_subnet.second_public.id
}
resource "aws_route_table" "first_private_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.first.id
  }
}
resource "aws_route_table" "second_private_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.second.id
  }
}
resource "aws_route_table_association" "associate_first_private" {
  subnet_id      = aws_subnet.first_private_web.id
  route_table_id = aws_route_table.first_private_subnet.id
}
resource "aws_route_table_association" "associate_second_private" {
  subnet_id      = aws_subnet.second_private_web.id
  route_table_id = aws_route_table.second_private_subnet.id
}

resource "aws_subnet" "first_private_rds" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.first_private_subnet_rds_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_subnet" "second_private_rds" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.second_private_subnet_rds_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
}

