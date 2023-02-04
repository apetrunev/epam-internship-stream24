terraform {
  required_providers {
    aws = {
      # global source address
      source  = "hashicorp/aws"
      # version constraints
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  # since aws provider >= v3.38.0
  default_tags {
    tags = {
      Owner   = "alexey_petrunev@epam.com"
      Project = "lab_task2" 
    }
  }
}

data "aws_ami" "debian" {
  most_recent = true
  # filter by name
  filter {
    name   = "name"
    values = ["debian-10-amd64-20210329-591"]
  }
  owners = ["136693071363"]
}

resource "aws_security_group" "nginx_sg" {
  description = "EC2 nginx SSH and HTTP"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgres_sg" {
  description = "RDS Postgres access"
  
  ingress {
    from_port   = 5432 
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_postgres" {
  identifier          = "lab"
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "12"
  instance_class      = "db.t3.micro"
  db_name             = var.dbname
  username            = var.dbuser
  password            = var.dbpassword 
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  skip_final_snapshot = true
}

resource "aws_instance" "ec2_nginx" {
  ami = data.aws_ami.debian.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get -y install nginx
  sudo systemct start nginx
  EOF
}
