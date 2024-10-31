resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = var.instance_user_data
  user_data_replace_on_change = true

  key_name = var.instance_key_name

  # Enable IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Merge tags with prefix
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ec2-instance"
    }
  )
}

resource "aws_ec2_instance_state" "ec2" {
  instance_id = aws_instance.ec2.id
  state       = var.instance_state
}
