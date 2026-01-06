//Launch Template

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

//Security group

resource "aws_security_group" "asg" {
  name   = "${var.project_name}-${var.environment}-asg-sg"
  vpc_id = var.vpc_id


  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }
  //SSH for testing
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-asg-sg"
  }
}


//Launch template SPOT

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-${var.environment}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.asg.id]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  instance_market_options {
    market_type = "spot"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y awscli
amazon-linux-extras install nginx1 -y

systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/*
aws s3 sync s3://terraform-aws-stack-dev-static/ /usr/share/nginx/html/

systemctl restart nginx
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-${var.environment}-asg-instance"
      Environment = var.environment
    }
  }
}

//ASG

resource "aws_autoscaling_group" "this" {
  name                = "${var.project_name}-${var.environment}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg"
    propagate_at_launch = true
  }
}

