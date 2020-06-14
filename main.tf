provider "aws" {
  version = "~> 2.66"

  profile = "default"
  region  = var.region.default
}

provider "aws" {
  alias = "virginia"
  region = var.region.virginia
}

resource "aws_instance" "london_ec2" {
  ami           = var.amis[var.region.default]
  instance_type = "t2.micro"
  # Adding a `depends on` argument means the s3 bucket will be created before the ec2 instance starts even though they can be created in parallel 
  depends_on = [aws_s3_bucket.tf_s3_bucket]

  # provisioner "local-exec" {
  #   command = "echo ${aws_instance.london_ec2.public_ip} > myip.txt"
  # }
}

resource "aws_instance" "virginia_ec2" {
  provider = aws.virginia

  ami = var.amis[var.region.virginia]
  instance_type = "t2.micro"
}

resource "aws_eip" "tf_elastic_ip" {
  vpc      = true
  instance = aws_instance.london_ec2.id
}

resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "soup-tf-test"
  acl    = "private"
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH into EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
