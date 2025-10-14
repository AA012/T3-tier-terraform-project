resource "aws_db_subnet_group" "apci_jupiter_db_subnet_group" {
  name       = "jupiter_db_subnet_group"
  subnet_ids = [var.apci_jupiter_db_subnet_az_1c, var.apci_jupiter_db_subnet_az_1d]

  
  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}db-subnet-group"

})
}

#create a sec group for the rds db
resource "aws_security_group" "apci_jupiter_rds_db_sg" {
  name        = "rds-db-sg"
  description = "Allow db traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "jupiter_rds_sg"
  }
}
#create inbound rule  
resource "aws_vpc_security_group_ingress_rule" "allow_db_traffic" {
  security_group_id = aws_security_group.apci_jupiter_rds_db_sg.id
  referenced_security_group_id = var.apci_jupiter_bastion_sg
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

#create outbound rule
resource "aws_vpc_security_group_egress_rule" "allow_all_db_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_rds_db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to allow all ports
}

#referencing an existing password from secrets manager
data "aws_secretsmanager_secret" "apci_jupiter_db_secret" {
  name = "jupiterdb"
}

#how to pull the current secrets in the secret manager
data "aws_secretsmanager_secret_version" "apci_jupiter_secret_version" {
  secret_id     = data.aws_secretsmanager_secret.apci_jupiter_db_secret.id
}

#create mysql db
resource "aws_db_instance" "apci_jupiter_mysqldb" {
  allocated_storage    = 10
  db_name              = "mysqldb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = jsondecode(data.aws_secretsmanager_secret_version.apci_jupiter_secret_version.secret_string)["mysql_password"]
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.apci_jupiter_rds_db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.apci_jupiter_db_subnet_group.name
  skip_final_snapshot  = true
}

