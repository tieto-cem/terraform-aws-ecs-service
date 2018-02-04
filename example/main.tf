provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

#---------------
# ECS Cluster
#---------------

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "test-cluster"
}

module "instance_sg" {
  source      = "github.com/tieto-cem/terraform-aws-sg?ref=v0.1.0"
  name        = "test-cluster-instance-sg"
  vpc_id      = "${data.aws_vpc.default.id}"
  allow_cidrs = {
    "80" = ["0.0.0.0/0"]
  }
}

module "container_instances" {
  source                = "github.com/tieto-cem/terraform-aws-ecs-container-instance?ref=v0.1.2"
  name_prefix           = "test-cluster"
  ecs_cluster_name      = "${aws_ecs_cluster.ecs_cluster.name}"
  lc_instance_type      = "t2.nano"
  lc_security_group_ids = ["${module.instance_sg.id}"]
  asg_subnet_ids        = "${data.aws_subnet_ids.default.ids}"
}

#----------------------
#  Task Definition
#----------------------

module "container_definition" {
  source         = "github.com/tieto-cem/terraform-aws-ecs-task-definition//modules/container-definition?ref=v0.1.1"
  name           = "hello-world"
  image          = "tutum/hello-world"
  mem_soft_limit = 256
  port_mappings  = [{
    containerPort = 80
    hostPort      = 80
  }]
}

module "task_definition" {
  source                = "github.com/tieto-cem/terraform-aws-ecs-task-definition?ref=v0.1.1"
  name                  = "mytask"
  container_definitions = ["${module.container_definition.json}"]
}


#-------------------
#  ECS Service
#-------------------

module "service" {
  source              = ".."
  name                = "myservice"
  cluster_name        = "${aws_ecs_cluster.ecs_cluster.name}"
  task_definition_arn = "${module.task_definition.arn}"
}

#------------------------------------
# Output public IPs of EC2 instances
#------------------------------------

data "aws_instances" "instances" {
  instance_tags {
    Name = "test-cluster*"
  }
  depends_on = ["module.container_instances"]
}

output "instance_test_url" {
  description = "URL for calling container running in ECS cluster"
  value       = <<EOF
tutum/hello-world container responds from following urls: "${join(", ", formatlist("http://%s", data.aws_instances.instances.public_ips))}"

Note that containers might not respond immediately.

EOF
}