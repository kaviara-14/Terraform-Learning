variable "ami_input" {
  description = "Enter the AMI Input"
  type = string
}

variable "instance_type_input" {
    description = "Enter the instance type input"
    default = "t2.micro"
    type = string
}

variable "input_key_Name" {
    description = "enter the key name input"
    type = string
    default = "default-key"
}

variable "input_instance_name" {
    description = "enter the instance name"
    type = string
}