provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "test_ec2" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
  # Adding a `depends on` argument means the s3 bucket will be created before the ec2 instance starts even though they can be created in parallel 
  depends_on = [aws_s3_bucket.tf_s3_bucket]

  # provisioner "local-exec" {
  #   command = "echo ${aws_instance.test_ec2.public_ip} > myip.txt"
  # }
}

resource "aws_eip" "tf_elastic_ip" {
  vpc      = true
  instance = aws_instance.test_ec2.id
}

resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "soup-tf-test"
  acl    = "private"
}