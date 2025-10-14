#this is where you come to reference declared variables
#create vpc
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}main-vpc"
})
}

#create 2 database subnets 
resource "aws_subnet" "apci_jupiter_db_subnet_az_1c" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.db_subnet_cidr_block[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}db_subnet_1c"
})
}

resource "aws_subnet" "apci_jupiter_db_subnet_az_1d" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.db_subnet_cidr_block[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}db_subnet_1d"
})
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}igw"
})
}
#create two public subnets
resource "aws_subnet" "apci_jupiter_public_az_1c" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}public-subnet-az-1c"
})
}

resource "aws_subnet" "apci_jupiter_public_az_1d" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}public-subnet-az-1d"
})
}

#create two private subnets
resource "aws_subnet" "apci_jupiter_private_az_1c" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-subnet-az-1c"
})
}

resource "aws_subnet" "apci_jupiter_private_az_1d" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-subnet-az-1d"
})
}

#create a public route table
resource "aws_route_table" "apci-aws_jupiter-public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}public-rt"
})
}

#creating a public route table association
resource "aws_route_table_association" "public_subnet_az_1c" {
  subnet_id      = aws_subnet.apci_jupiter_public_az_1c.id
  route_table_id = aws_route_table.apci-aws_jupiter-public_rt.id
}

resource "aws_route_table_association" "public_subnet_az_1d" {
  subnet_id      = aws_subnet.apci_jupiter_public_az_1d.id
  route_table_id = aws_route_table.apci-aws_jupiter-public_rt.id
}


#create an elastic ip for AZ 1C nat gw
resource "aws_eip" "eip_az_1c" {
  domain   = "vpc"
tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}eip-az-1c"
})
}

#create a nat gateway for az 1c
resource "aws_nat_gateway" "apci_jupiter_nat_gw_az_1c" {
  allocation_id = aws_eip.eip_az_1c.id
  subnet_id     = aws_subnet.apci_jupiter_public_az_1c.id

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}nat-gw-az-1c"
})

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_az_1c, aws_subnet.apci_jupiter_public_az_1c]
}

#create a private route table for 1c
resource "aws_route_table" "apci-aws_jupiter-priavte_rt_az_1c" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_jupiter_nat_gw_az_1c.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-rt"
})
}
#create private route table association for az 1c
resource "aws_route_table_association" "private_subnet_az_1c" {
  subnet_id      = aws_subnet.apci_jupiter_private_az_1c.id
  route_table_id = aws_route_table.apci-aws_jupiter-priavte_rt_az_1c.id
}

resource "aws_route_table_association" "db_subnet_az_1c" {
  subnet_id      = aws_subnet.apci_jupiter_db_subnet_az_1c.id
  route_table_id = aws_route_table.apci-aws_jupiter-priavte_rt_az_1c.id
}

#create an elstic ip for AZ 1d nat gw - THIS IS NEW
resource "aws_eip" "eip_az_1d" {
  domain   = "vpc"
tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}eip-az-1d"
})
}

#create a nat gateway for az 1d
resource "aws_nat_gateway" "apci_jupiter_nat_gw_az_1d" {
  allocation_id = aws_eip.eip_az_1d.id
  subnet_id     = aws_subnet.apci_jupiter_public_az_1d.id

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}nat-gw-az-1d"
})

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_az_1d, aws_subnet.apci_jupiter_public_az_1d]
}

#create a private route table for 1d
resource "aws_route_table" "apci-aws_jupiter-priavte_rt_az_1d" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_jupiter_nat_gw_az_1d.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-rt"
})
}
#create private route table association for az 1d
resource "aws_route_table_association" "private_subnet_az_1d" {
  subnet_id      = aws_subnet.apci_jupiter_private_az_1d.id
  route_table_id = aws_route_table.apci-aws_jupiter-priavte_rt_az_1d.id
}

resource "aws_route_table_association" "db_subnet_az_1d" {
  subnet_id      = aws_subnet.apci_jupiter_db_subnet_az_1d.id
  route_table_id = aws_route_table.apci-aws_jupiter-priavte_rt_az_1d.id
}