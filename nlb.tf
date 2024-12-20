resource "aws_lb" "example" {
  name               = "network"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.sn1.id
    allocation_id = aws_eip.NatGateway_eip.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.sn3.id
    allocation_id = aws_eip.NatGateway_eip.id
  }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 3000
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.my-vpc.id

 health_check {
   path = "/"
 }
}

resource "aws_lb_target_group" "ecs_tg2" {
 name        = "ecs-target-group2"
 port        = 3000
 protocol    = "HTTPS"
 target_type = "ip"
 vpc_id      = aws_vpc.my-vpc.id

 health_check {
   path = "/"
 }
}

resource "aws_lb_listener" "nlb_http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "3000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_listener" "nlb_https" {
  load_balancer_arn = aws_lb.example.arn
  port              = "3000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg2.arn
  }
}


