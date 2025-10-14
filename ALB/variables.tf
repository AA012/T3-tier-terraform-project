#use this to call the resource from other modules
variable "vpc_id" {
  type = string
}

#use this to call the subnets variable
variable "apci_jupiter_public_az_1c" {
  type = string
}

variable "apci_jupiter_public_az_1d" {
  type = string
}

#create a tags variable
variable "tags" {
  type = map(string)
}
#create a variable for ssl policy
variable "ssl_policy" {
  type = string
}
#create a variable for certificate arn 
variable "certificate_arn" {
  type = string
}