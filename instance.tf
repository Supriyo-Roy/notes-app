//creating an EC2 instance
resource "aws_instance" "web" {
  ami           = "${var.ami_type}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.key_pair.key_name}" 
  security_groups = ["${aws_security_group.allow_tls.name}","default"]

  tags = {
    Name = "Terraform-EC-2"
  }
  //this states that EC2 instance will only be created after aws_key_pair resouce is created
  depends_on = [
    aws_key_pair.key_pair
    
  ]
 }
//creating key_pair login
resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = "${tls_private_key.private_key.public_key_openssh}"
    depends_on = [
    tls_private_key.private_key
  ]
}
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}
//local_file resource helps to create a file locally

resource "local_file" "file" {
  content  = "${tls_private_key.private_key.private_key_pem}"
  filename = "private.pem"
}

//creating a security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow ssh and http  traffic"
  
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]

  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
}
