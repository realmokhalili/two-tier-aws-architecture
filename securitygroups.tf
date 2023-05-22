resource "aws_security_group" "lb" {
    vpc_id = aws_vpc.real.id
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/24"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "backend" {
    description = "allow only ssh and http from load balancer"
    vpc_id = aws_vpc.real.id
    ingress {
      from_port = 8000
      to_port = 8000
      protocol = "tcp"
      security_groups = [aws_security_group.lb.id]
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_security_group" "database" {
    vpc_id = aws_vpc.real.id
    dynamic "ingress" {
      for_each = var.database_open_ports
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/24"]
        ipv6_cidr_blocks = ["::/0"]
      }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}