variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet" {
  type    = list(string)
  default = ["192.168.3.0/24", "192.168.4.0/24"]
}


variable "backend_open_ports" {
  type = list(number)
  default = [22, 8000]
}

variable "database_open_ports" {
  type = list(number)
  default = [22, 5432]
}

variable "backend_image" {
  type = object({
    ami = string
    type = string
  })
  default = {
  ami = "ami-0ac59804e0c10a625",
  type = "t3.micro"
  }
}
