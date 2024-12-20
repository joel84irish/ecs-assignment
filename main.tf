resource "aws_vpc" "my-vpc" {
 cidr_block = var.vpc_cidr
}

resource "aws_subnet" "sn1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sn2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
}
#
resource "aws_subnet" "sn3" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "PrivateSubnet"
  }
}

resource "aws_eip" "NatGateway_eip" {
  tags = {
    Name    = "NatGatewayEIP"
  }
}
resource "aws_nat_gateway" "NatGateway" {
  allocation_id = aws_eip.NatGateway_eip.id
  subnet_id     = aws_subnet.sn3.id
  tags = {
    Name    = "NatGateway"

  }


}
resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description      = "http"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg2" {

  ingress {
    description      = "htts"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGateway.id
  }
  tags = {
    Name    = "Private"
  }
}
resource "aws_route_table_association" "route1" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.sn1.id
}

resource "aws_route_table_association" "route2" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.sn2.id
}

resource "aws_network_interface" "ecs_eni" {
  subnet_id = aws_subnet.sn1.id
  security_groups = [aws_security_group.sg.id]
}

resource "aws_eip_association" "example" {
  network_interface_id = aws_network_interface.ecs_eni.id
  allocation_id = aws_eip.NatGateway_eip.id
}


