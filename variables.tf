#Any variable that can be used in any services can be declared in herer
variable "vpc_cidr_block" {
  type = string
}

#define the public subnet variable 
variable "public_subnet_cidr_block" {
  type = list(string)
}

#define the private subnet variable 
variable "private_subnet_cidr_block" {
  type = list(string)
}

#define db subnet cidr block 
variable "db_subnet_cidr_block" {
  type = list(string)
}

#define availability_zone
variable "availability_zone" {
  type = list(string)
}

#create a variable for image id 
variable "image_id" {
  type = string
}
#create a variable for instance type 
variable "instance_type" {
  type = string
}
#create a variable for key name 
variable "key_name" {
  type = string
}
#creat a variable for db user name 
variable "db_username" {
  type = string
}

#create a variable for hosted zone id 
variable "dns_zone_id" {
  type = string
}
#create a variable for hosted zone name 
variable "dns_name" {
  type = string
}
#create a variable for ssl policy
variable "ssl_policy" {
  type = string
}
#create a variable for certificate arn 
variable "certificate_arn" {
  type = string
}