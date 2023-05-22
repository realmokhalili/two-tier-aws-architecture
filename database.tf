resource "aws_db_subnet_group" "real" {
  name = "real"
  subnet_ids = aws_subnet.private[*].id
}
resource "aws_db_instance" "real" {
  identifier             = "real"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "real"
  password               = "test"
  db_subnet_group_name   = aws_db_subnet_group.real.name
  vpc_security_group_ids = [aws_security_group.database.id]
}