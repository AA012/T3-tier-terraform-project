#create a sec group for bastion host
resource "aws_security_group" "apci_jupiter_bastion_sg" {
  name        = "apci_jupiter_bastion_sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bastion_host_sg"
  }
}

#define the inbound rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_ssh_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#create the bastion host
resource "aws_instance" "apci_jupiter_bastion_host" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    associate_public_ip_address = true
    subnet_id = var.apci_jupiter_public_az_1c
    security_groups = [aws_security_group.apci_jupiter_bastion_sg.id]

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}bastion-host"
})
}

#create a sec group for private servers
resource "aws_security_group" "apci_jupiter_private_server_sg" {
  name        = "apci_jupiter_private_server_sg"
  description = "Allow SSH traffic from bastion host"
  vpc_id      = var.vpc_id

  tags = {
    Name = "private_server_sg"
  }
}

#define the inbound rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_host" {
  security_group_id = aws_security_group.apci_jupiter_private_server_sg.id
  referenced_security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_bastion_ssh_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_private_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#creating private server for 1c
resource "aws_instance" "apci_jupiter_private_server_1c" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    associate_public_ip_address = false
    subnet_id = var.apci_jupiter_private_az_1c
    security_groups = [aws_security_group.apci_jupiter_private_server_sg.id]

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-server-1c"
})
}

#create private server for 1d
resource "aws_instance" "apci_jupiter_private_server_1d" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    associate_public_ip_address = false
    subnet_id = var.apci_jupiter_private_az_1d
    security_groups = [aws_security_group.apci_jupiter_private_server_sg.id]

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}private-server-1d"
})
}