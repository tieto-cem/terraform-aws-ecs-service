resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.name}-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attachment" {
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_service" "ecs_service_without_lb" {
  count                              = "${var.use_load_balancer ? 0 : 1}"
  name                               = "${var.name}"
  launch_type                        = "${var.launch_type}"
  cluster                            = "${var.cluster_name}"
  task_definition                    = "${var.task_definition_arn}"
  desired_count                      = "${var.desired_count}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

  depends_on                         = ["aws_iam_role_policy_attachment.ecs_service_role_policy_attachment"]

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }

}

resource "aws_ecs_service" "ecs_service_with_lb" {
  count                              = "${var.use_load_balancer ? 1 : 0}"
  name                               = "${var.name}"
  launch_type                        = "${var.launch_type}"
  cluster                            = "${var.cluster_name}"
  task_definition                    = "${var.task_definition_arn}"
  desired_count                      = "${var.desired_count}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  iam_role                           = "${aws_iam_role.ecs_service_role.arn}"
  health_check_grace_period_seconds  = "${var.health_check_grace_period_seconds}"

  depends_on                         = ["aws_iam_role_policy_attachment.ecs_service_role_policy_attachment"]

  load_balancer {
    target_group_arn = "${var.lb_target_group_arn}"
    container_name   = "${var.lb_container_name}"
    container_port   = "${var.lb_container_port}"
  }

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }

}