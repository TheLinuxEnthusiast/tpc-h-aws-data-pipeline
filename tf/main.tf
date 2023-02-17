terraform {

  backend "s3" {
    bucket = "tpc-h-terraform-state-df"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = true
  keepers = {
    rand_id = "1000"
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic to ec2"
  vpc_id      = var.aws_vpc

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["37.228.207.153/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_security_group" "allow_access_to_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres access"
  vpc_id      = var.aws_vpc

  ingress {
    description = "Access to postgres from ec2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      "${aws_security_group.allow_ssh.id}",
    ]
  }

  ingress {
    description = "Access from local machine"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["37.228.207.153/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_5432"
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "ec2-s3-rds-role"
  assume_role_policy = "${file("bootstrap/assumeRole.json")}"
}

resource "aws_iam_policy" "ec2_rds_load_policy" {
  name        = "ec2-rds-load-policy"
  description = "A policy for loading RDS from an EC2 instance"
  policy      = "${file("bootstrap/policy.json")}"
  tags = {
      Name = "${var.prefix}"
  }
}

resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "policy-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.ec2_rds_load_policy.arn}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name  = "ec2-s3-rds-profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}

resource "aws_db_instance" "tpc_h_db" {
  identifier_prefix      = "tpch"
  allocated_storage      = 10
  db_name                = "tpchdb01"
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  username               = var.username
  password               = var.password
  port                   = var.port
  availability_zone      = var.availability_zone
  parameter_group_name   = "default.postgres14"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.allow_access_to_postgres.id]
}


resource "aws_instance" "load_dev_data" {
  count = var.active ? 1 : 0
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = "ec2-key-pair"

  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"

  associate_public_ip_address = true

  vpc_security_group_ids = [ "${aws_security_group.allow_ssh.id}" ]

  user_data = <<EOF
    #!/bin/bash

    sudo yum update
    sudo yum install -y telnet
    sudo yum install -y amazon-linux-extras
    sudo amazon-linux-extras install postgresql14

    mkdir -p /home/ec2-user/data/
    mkdir -p /home/ec2-user/sql

    sudo chown -R ec2-user:ec2-user /home/ec2-user/data/
    sudo chown -R ec2-user:ec2-user /home/ec2-user/sql/

    aws s3 cp s3://tpc-h-raw-data-df/raw/customer.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/lineitem.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/nation.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/orders.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/part.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/partsupp.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/region.tbl /home/ec2-user/data/
    aws s3 cp s3://tpc-h-raw-data-df/raw/supplier.tbl /home/ec2-user/data/
    
    aws s3 cp s3://tpc-h-raw-data-df/sql/tables.sql /home/ec2-user/sql/
    aws s3 cp s3://tpc-h-raw-data-df/sql/load_data.sh /home/ec2-user/sql/
    
    sudo chmod +x /home/ec2-user/sql/load_data.sh

    sudo chown ec2-user:ec2-user /home/ec2-user/sql/load_data.sh
    sudo chown ec2-user:ec2-user /home/ec2-user/sql/tables.sql

    #Run a psql statement in batch
    sudo echo "${aws_db_instance.tpc_h_db.address}" > /home/ec2-user/address.txt
    sudo psql -h "${aws_db_instance.tpc_h_db.address}" -U awsuser -d tpchdb01 -p 5432 -f /home/ec2-user/sql/tables.sql

    # Load the data
    sudo /home/ec2-user/sql/load_data.sh "${var.password}" "${aws_db_instance.tpc_h_db.address}"
    
  EOF

  tags = {
    Name = "${var.prefix}"
  }
}

