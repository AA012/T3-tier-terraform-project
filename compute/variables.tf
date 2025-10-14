variable "vpc_id" {
  type = string
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

#create a variable for public subnet
variable "apci_jupiter_public_az_1c" {
  type = string
}

#create a variable for public subnet
variable "apci_jupiter_public_az_1d" {
  type = string
}

#create a variable for a tag
variable "tags" {
  type = map(string)
}

#create a variable for private subnet
variable "apci_jupiter_private_az_1c" {
  type = string
}

#create a variable for private subnet
variable "apci_jupiter_private_az_1d" {
  type = string
}