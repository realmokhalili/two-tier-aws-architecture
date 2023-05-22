resource "aws_vpc" "real" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "real_vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet)
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.public_subnet[count.index]
  vpc_id                  = aws_vpc.real.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = length(var.public_subnet)
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.private_subnet[count.index]
  vpc_id            = aws_vpc.real.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.real.id
  tags = {
    Name = "real_gw"
  }
}

resource "aws_eip" "nat_ip" {
  count = length(var.availability_zones)
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.real.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  count  = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "privates" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.real.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privates[count.index].id
}
