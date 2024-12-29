
resource "aws_ecs_service" "SERVICE_APP_FINAL" {
  name = "TERRAFORM_SERVICE"
  cluster                = aws_ecs_cluster.TERRAFORM_CLUSTER.arn
  task_definition        = aws_ecs_task_definition.ECS_TASK_DEFINITION_APP.arn  
  launch_type            = "FARGATE"
  desired_count          = 2  
  force_new_deployment   = true  
  enable_execute_command = true
  
  
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg-tf.id]
    subnets          = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = "app"
    container_port = 3000
  }
}

  #deployment_maximum_percent         = 200
  #deployment_minimum_healthy_percent = 100
