# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Create Subnets
resource "aws_subnet" "subnets" {
  count = 4
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.subnets_cidr[count.index]
  map_public_ip_on_launch = true
}

# Associate subnets with route table
resource "aws_route_table_association" "rta" {
   count = 4
   subnet_id = aws_subnet.subnets[count.index].id
   route_table_id = aws_route_table.public_rt.id
}

# Security Group creation
resource "aws_security_group" "websg" {
  name = "web"
  vpc_id = aws_vpc.main_vpc.id
   dynamic "ingress" {
     for_each = var.allowed_ports
     content {
       from_port = ingress.value
       to_port = ingress.value
       protocol = "tcp"
       cidr_blocks = [ "0.0.0.0/0" ]
     }
     }
     egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

# Create 4 EC2 instances with different subnets
resource "aws_instance" "instances" {
  count = 4
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnets[count.index].id
  security_groups = [ aws_security_group.websg.id ]
  associate_public_ip_address = true
  key_name = "Terraformdemo"
}
