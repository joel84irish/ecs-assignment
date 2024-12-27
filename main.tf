resource "aws_vpc" "my-vpc-tf" {
 cidr_block = var.vpc_cidr
}

resource "aws_subnet" "sn1" {
  vpc_id                  = aws_vpc.my-vpc-tf.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "PublicSubnet-tf"
  }
}

resource "aws_subnet" "sn2" {
  vpc_id                  = aws_vpc.my-vpc-tf.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name    = "PublicSubnet2-tf"
  }
}


resource "aws_internet_gateway" "gw-tf" {
  vpc_id = aws_vpc.my-vpc-tf.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-tf.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw-tf.id
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


resource "aws_security_group" "sg-tf" {
  name        = "TERRAFORM"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc-tf.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  }

resource "aws_network_interface" "ecs_eni-tf" {
  subnet_id = aws_subnet.sn1.id
  security_groups = aws_security_group.sg-tf.id
}
