terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "phesse"
  region  = "us-east-1"
}

variable "ami_name" {
    type = string
    default = "ubuntu"
}
variable "ami_id" {
    type = string
    default = "ami-083654bd07b5da81d"
}


resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_default_vpc.default.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "single_core_server" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "aws_key"
  vpc_security_group_ids = ["${aws_security_group.ingress-all-test.id}"]

  tags = {
    Name = "${var.ami_name}"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.single_core_server.id}"
  vpc      = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClLKG7cHV5j4MnSBmMl/dZEV64ZRm0n6RlIXx7GwVy4Y4TK9uwaL9UPSSBSh7BFw6+W8oM9oYM6wrCmKSrdYdXSDMm2jZZqysBovZ/ST9v1zA3KdH3Uyh/mupJrbwkTtd8WVNlA2U6bRDXbYHavMJKs/vDT0rUgqEpixCPrQIPwkIVfuAB7rmaYVqGYIsPLNVpySTfHF38DVtaz403s8M74hM3ETq8Wvz3jJURPENEqDRlGNsoxsbVCA//TbHSRONGM3+ZKvDW+VVPIMI5syBzVr4vwEiNiv4soTVScsOGXx+vD0yGZEpsOdnfUqMgDqqSGjo8+mcYVOR0+kU25Xbr phesse@phesse"
}

