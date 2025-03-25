variable "aws_region" {
  description = "AWS Region"
  type = string
  }

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type = string
  }

variable "subnets_cidr" {
  description = "list of subnets cidr"
  type = list(string)
 }

variable "instance_type" {
  description = "ec2 instance type"
  type = string
 }

variable "ami_id" {
  description = "enter the ami id"  
  type = string
  }

  variable "allowed_ports" {
    description = "enter the port numbers"
    type = list(number)
    }
