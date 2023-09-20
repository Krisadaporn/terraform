provider "aws" {
    // provider = import library
    // AWS User needs necessary permissions! like AmazonEC2FullAccess
  region = "ap-southeast-1"
}

variable "cidr_block" {
  description = "cidr blocks and name for vpc and subnet"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

resource "aws_vpc" "development-vpc" {
    //resource/data = function call of library
  cidr_block = var.cidr_block[0].cidr_block
  tags = {
    Name: var.cidr_block[0].name,
    vpc_env: "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.cidr_block[1].cidr_block
  availability_zone = "ap-southeast-1a"
  tags = {
    Name: var.cidr_block[1].name
  }
}

variable "avail_zone" {
  
}

data "aws_vpc" "existing_vpc" {
     //arguments = parameters of function
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = var.avail_zone
  tags = {
    Name: "subnet-2-default"
  }
}
