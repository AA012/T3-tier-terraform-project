#AWS resources get declared as a variable here
variable "tags" {
  type = map(string)
}

#variable for vpc cidr block 
variable "vpc_cidr_block" {
  type = string
}

#variable for public subnet 
variable "public_subnet_cidr_block" {
  type = list(string)
}

#variable for private subnet 
variable "private_subnet_cidr_block" {
  type = list(string)
}

#variable for db subnet
variable "db_subnet_cidr_block" {
  type = list(string)
}

#define availability_zone
variable "availability_zone" {
  type = list(string)
}