resource "aws_ecs_cluster" "main" {
  name = "ecs-project-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Task Definition

resource "aws_ecs_task_definition" "main" {
  family                   = "ecs-project-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-project-container"
      image     = var.ecr_repository
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}


# ECS Security Group

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-project-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id
}


# Allow ALB to reach ECS on port 3000

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs_sg.id

  referenced_security_group_id = var.alb_security_group_id

  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
}


# ECS Task Execution Role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


# Give ECS Task Execution Role the required permissions

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS Service

resource "aws_ecs_service" "main" {
  name            = "ecs-project-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      var.subnet_1_id,
      var.subnet_2_id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ecs-project-container"
    container_port   = 3000
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution
  ]
}
