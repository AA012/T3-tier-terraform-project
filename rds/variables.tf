#variable for public subnet 
variable "apci_jupiter_db_subnet_az_1c" {
  type = string
}

#variable for private subnet 
variable "apci_jupiter_db_subnet_az_1d" {
  type = string
}

#variable for tags
variable "tags" {
  type = map(string)
}
#variable for vpc
variable "vpc_id" {
  type = string
}
#variable for bastion host sg
variable "apci_jupiter_bastion_sg" {
  type = string
}
#creat a variable for username 
variable "db_username" {
  type = string
}
