provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_instance" "tf_ec2" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
}

resource "aws_eip" "tf_elastic_ip" {
  vpc = true
  instance = ${aws_instance.tf_ec2.id}
}