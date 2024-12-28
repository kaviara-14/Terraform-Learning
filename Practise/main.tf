provider "aws" {
  region = "us-east-1"
}

module "name" {
  source = "./modules"
  ami_input = "ami_1234"
  input_instance_name = "2332111"
}

output "name" {
  value = module.name.public_ip
}