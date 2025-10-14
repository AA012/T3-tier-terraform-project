#create a variable for hosted zone id 
variable "dns_zone_id" {
  type = string
}
#create a variable for hosted zone name 
variable "dns_name" {
  type = string
}
#create a variable for alb dns name
variable "apci_jupiter_alb" {
  type = string
}
#create a variable for alb dns zone id 
variable "apci_jupiter_alb_zone_id" {
   type = string 
}