resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/18" #using /18 for Dev

  tags = {
    Name = "dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_ap-south_1a" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.0.0/20" #1st Subnet 10.0.0.0/18+2 i.e. 20
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-ap-south-1a"
  }
}

resource "aws_subnet" "public_ap-south_1b" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.16.0/20" #2nd subnet 18+2 i.e. 20 and slots of 16
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-ap-south-1b"
  }
}

resource "aws_subnet" "private_ap-south_1a" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.32.0/20" #3rd subnet 18+2 i.e. 20 and slots of 16
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "private-ap-south-1a"
  }
}

resource "aws_subnet" "private_ap-south_1b" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.48.0/20" #4th subnet 18+2 i.e. 20 and slots of 16
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "private-ap-south-1b"
  }
}

resource "aws_security_group" "dev-SG" {
  name        = "dev-SG"
  description = "dev Security Group"
    vpc_id      = aws_vpc.dev.id

  ingress {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_server" {
  ami           = "ami-067c21fb1979f0b27"
  instance_type = "t2.micro"
  key_name               = "forWipro"
  subnet_id              = aws_subnet.public_ap-south_1a.id
  vpc_security_group_ids = [aws_security_group.dev-SG.id]

  tags = {
    Name = "DevEc2"
    }
}

#terraform destroy -target=aws_vpc.dev -target=aws_internet_gateway.igw -target=aws_subnet.public_ap-south_1a -target=aws_subnet.public_ap-south_1b -target=aws_subnet.private_ap-south_1a -target=aws_subnet.private_ap-south_1b -target=aws_security_group.dev-SG
