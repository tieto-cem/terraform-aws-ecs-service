variable "name" {
  description = "The name of the service"
}

variable "cluster_name" {
  description = "ARN of an ECS cluster"
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
  default     = "EC2"
}

variable "task_definition_arn" {
  description = "The family and revision (family:revision) or full ARN of the task definition that you want to run in your service."
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 100
}
variable "deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
  default     = 200
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers"
  default     = 0
}

#-------------------------------
# Placement strategy settings
#-------------------------------

variable "placement_strategy_type" {
  description = "The type of placement strategy. Must be one of: binpack, random, or spread"
  default = "spread"
}

variable "placement_strategy_field" {
  description = <<EOF
For the spread placement strategy, valid values are instanceId (or host, which has the same effect),
or any platform or custom attribute that is applied to a container instance. For the binpack type,
valid values are memory and cpu. For the random type, this attribute is not needed.
EOF
  default = "attribute:ecs.availability-zone"
}

#-------------------------------
# Load balancer settings
#-------------------------------

variable "use_load_balancer" {
  description = "Whether to use load balancer with your service or not"
  default     = false
}

variable "lb_target_group_arn" {
  description = <<EOF
    ALB target group to which register container instances.
    This parameter is only required if you are using a load balancer with your service.
EOF
  default     = ""
}

variable "lb_container_name" {
  description = <<EOF
      The name of the container (as it appears in a container definition) to associate with the load balancer.
      This parameter is only required if you are using a load balancer with your service.
EOF
  default     = ""
}

variable "lb_container_port" {
  description = <<EOF
    The name of the container to associate with the load balancer (as it appears in a container definition).
    This parameter is only required if you are using a load balancer with your service.
EOF
  default     = ""
}




