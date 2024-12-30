#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer" {
  name                      = "TERRAFORM-alb"
  internal                  = false
  load_balancer_type        = "application"
  subnets                   = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  security_groups           = [aws_security_group.sg-tf.id]
}

#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group" {
  name                      = "TERRAFORM-tg"
  port                      = var.container_port
  protocol                  = "HTTP"
  target_type               = "ip"
  vpc_id                    = aws_vpc.my-vpc-tf.id
  health_check {
      path                  = "/health"
      protocol              = "HTTP"
      matcher               = "200"
      port                  = "traffic-port"
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      timeout               = 10
      interval              = 30
  }
}

#Defines an HTTP Listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn         = aws_alb.application_load_balancer.arn
  port                      = "80"
  protocol                  = "HTTP"

  default_action {
    type                    = "forward"
    target_group_arn        = aws_lb_target_group.target_group.arn
  }
}