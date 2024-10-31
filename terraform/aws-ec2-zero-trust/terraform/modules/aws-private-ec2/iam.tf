resource "aws_iam_role" "instance_role" {
  name = "${var.prefix}_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_instance_role"
    }
  )
}


resource "aws_iam_role_policy_attachment" "instance_role_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.prefix}_instance_profile"
  role = aws_iam_role.instance_role.name
}
