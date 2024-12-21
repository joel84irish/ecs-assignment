resource "aws_ecs_cluster" "ecs" {
 name = "my-ecs-cluster3"
}

resource "aws_ecs_service" "service3" {
  name = "service_2"
  cluster                = aws_ecs_cluster.ecs.arn
  launch_type            = "FARGATE"
  enable_execute_command = true

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.td.arn

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name = "app"
    container_port = 3000"
   }
   
  depends on   = [aws_lb_target_group.target_group.id]  
}


resource "aws_ecs_task_definition" "td" {
  container_definitions = jsonencode([
   {
     name      = "app"
     image     = "766261352911.dkr.ecr.us-west-2.amazonaws.com/app"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 3000
         hostPort      = 3000
         protocol      = "tcp"
       }
     ]
   }
 ])

 family                   = "app"
 requires_compatibilities = ["FARGATE"]

 cpu                      = "256"
 memory                   = "512"

 network_mode             = "awsvpc"
 task_role_arn            = "arn:aws:iam::766261352911:role/ecsTaskExecutionRole"
 execution_role_arn       = "arn:aws:iam::766261352911:role/ecsTaskExecutionRole"
 
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "ARM64"
 }
 
}


  
