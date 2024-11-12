resource "aws_instance" "ec2_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  security_groups      = var.security_group_ids
  key_name             = "yasmin-ec2-key"
  user_data            = file("${path.module}/script/init.sh")
  iam_instance_profile = aws_iam_instance_profile.admin_instance_profile.name

  tags = {
    Name = "${var.name}_jenkins_ec2"
  }
}

resource "aws_iam_instance_profile" "admin_instance_profile" {
  name = "AdminInstanceProfile"
  role = var.admin_role_name
}