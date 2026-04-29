terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  Name = "multi-resources"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.Name}-vpc"
  }
}

  resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index}.0/24"
    count = 2
    tags = {
      Name = "${local.Name}-subnet-${count.index}"
    }
  }

  resource "aws_instance" "name" {
    for_each = var.ec2_maap
    ami = each.value.ami
    instance_type = each.value.instance_type
    
    subnet_id = aws_subnet.public[each.key == "ubuntu" ? 0 : 1].id

    tags = {
      Name = "${local.Name}-instance-${each.key}"
    }
  }

output "ec2_os_with_subnets" {
  value = [
    for key, instance in aws_instance.name : {
      ec2_name = instance.tags.Name
      os       = key

      subnet_name = aws_subnet.public[
        index(aws_subnet.public[*].id, instance.subnet_id)
      ].tags.Name

      subnet_cidr = aws_subnet.public[
        index(aws_subnet.public[*].id, instance.subnet_id)
      ].cidr_block

      message = format(
        "Instance %s (%s) is in subnet %s (%s)",
        instance.tags.Name,
        key,
        aws_subnet.public[
          index(aws_subnet.public[*].id, instance.subnet_id)
        ].tags.Name,
        aws_subnet.public[
          index(aws_subnet.public[*].id, instance.subnet_id)
        ].cidr_block
      )
    }
  ]

  description = "Shows EC2 instances with OS and subnet detail"
}