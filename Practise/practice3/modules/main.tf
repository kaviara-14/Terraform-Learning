resource "aws_security_group" "name" {
    name = "ssh"
    description = "ssh access"
    vpc_id = "1290001001"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_instance" "name" {
    ami = var.ami_input
    instance_type = var.instance_type_input
    key_name = var.input_key_Name
    security_groups = [ aws_security_group.name ]

    tags = {
      Name = var.input_instance_name
    }
}