#create resources to be shared by modules
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

#create a public subnet resouce to be used for 1c
output "apci_jupiter_public_az_1c" {
  value = aws_subnet.apci_jupiter_public_az_1c.id
}

#create a public subnet resource to be used for 1d
output "apci_jupiter_public_az_1d" {
  value = aws_subnet.apci_jupiter_public_az_1d.id
}

#create a private subnet resouce to be used for 1c
output "apci_jupiter_private_az_1c" {
  value = aws_subnet.apci_jupiter_private_az_1c.id
}

#create a private subnet resource to be used for 1d
output "apci_jupiter_private_az_1d" {
  value = aws_subnet.apci_jupiter_private_az_1d.id
}

#create a db subnet resource to be used for 1c
output "apci_jupiter_db_subnet_az_1c" {
  value = aws_subnet.apci_jupiter_db_subnet_az_1c.id
}

#create a db subnet resource to be used for 1d
output "apci_jupiter_db_subnet_az_1d" {
  value = aws_subnet.apci_jupiter_db_subnet_az_1d.id
}