
variable "name" {}

variable "cluster_name" {}

variable "task_definition_arn" {}

variable "desired_count" {
  description = "How many tasks to run"
  default = 1
}

variable "deployment_minimum_healthy_percent" {
  default = 100
}
variable "deployment_maximum_percent" {
  default = 200
}

variable "container_name" {
  description = "The name of the container (as it appears in a container definition) to associate with the load balancer."
}

variable "container_port" {
  description = "This port must correspond to a containerPort in the service's task definition."
}

variable "target_group_arn" {
  description = "ALB target group to which register container instances"
}

variable "placement_strategy_type" {
  default = "spread"
}

variable "placement_strategy_field" {
  default = "attribute:ecs.availability-zone"
}