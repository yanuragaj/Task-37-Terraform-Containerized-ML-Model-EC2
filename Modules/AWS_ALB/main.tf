provider "aws"{
    region = "ap-south-1"
    profile = "default"
    }

resource "aws_lb" "ALB" {
  name               = "Task-37-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-e8d92796"]
  subnets            = ["subnet-ae13ecc5","subnet-7215393e"]

  
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}