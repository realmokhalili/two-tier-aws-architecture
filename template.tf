resource "aws_launch_template" "backend" {
    image_id = var.backend_image.ami
    instance_type = var.backend_image.type
    vpc_security_group_ids = [aws_security_group.backend.id]

    tags = {
        Name = "backend-template"
    }
}