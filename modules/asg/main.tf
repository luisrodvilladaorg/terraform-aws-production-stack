terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-asg-sg"
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
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
set -e

exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

echo "=== USER DATA START ==="
date

# Update system
yum update -y

# Install awscli (needed for S3)
yum install -y awscli

# Install nginx
amazon-linux-extras install nginx1 -y
systemctl enable nginx

# Sync static site
rm -rf /usr/share/nginx/html/*
aws s3 sync s3://terraform-aws-stack-dev-static/ /usr/share/nginx/html/

# Install Node.js 16 (Amazon Linux 2 compatible)
curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs

node -v
npm -v

# Backend setup
mkdir -p /opt/backend

cat << 'APP' > /opt/backend/index.js
const express = require("express");
const os = require("os");
const { Pool } = require("pg");

const app = express();

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

app.get("/api/ping", (req, res) => {
  res.json({ status: "ok", host: os.hostname() });
});

app.get("/api/ping-db", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json({ status: "ok", time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: "error", message: err.message });
  }
});

app.listen(3000, () => {
  console.log("Backend running on port 3000");
});
APP

cd /opt/backend
npm init -y
npm install express pg

# systemd backend service
cat << 'SERVICE' > /etc/systemd/system/backend.service
[Unit]
Description=Node Backend
After=network.target

[Service]
Environment=DB_HOST=${var.db_host}
Environment=DB_USER=${var.db_user}
Environment=DB_PASSWORD=${var.db_password}
Environment=DB_NAME=${var.db_name}
ExecStart=/usr/bin/node /opt/backend/index.js
WorkingDirectory=/opt/backend
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable backend
systemctl start backend

# Nginx reverse proxy
cat << 'NGINX' > /etc/nginx/conf.d/backend.conf
server {
  listen 80;

  location /api/ {
    proxy_pass http://127.0.0.1:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
NGINX

rm -f /etc/nginx/conf.d/default.conf
systemctl restart nginx

echo "=== USER DATA END ==="
date
EOF
  )


  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name        = "${var.project_name}-${var.environment}-asg-instance"
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "Terraform"
      },
      var.tags
    )
  }

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-lt"
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
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

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

