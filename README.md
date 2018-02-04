[![CircleCI](https://circleci.com/gh/tieto-cem/terraform-aws-ecs-task-definition.svg?style=shield&circle-token=549ec46ff06d26b4c86715e054bc03ac7f152533)](https://circleci.com/gh/tieto-cem/terraform-aws-ecs-task-definition)

AWS ECS Service Terraform module
===========================================

Terraform module which creates ECS Service. 

Usage
-----   

```hcl
module "service" {
  source              = ".."
  name                = "myservice"
  cluster_name        = "${aws_ecs_cluster.ecs_cluster.name}"
  task_definition_arn = "${module.task_definition.arn}"
}
```

Resources
---------

This module creates following AWS resources:

| Name                                        | Type                 | 
|---------------------------------------------|----------------------|
|${var.name}-service-role                     | IAM Role             | 
|${var.name}                                  | ECS Service          |


Example
-------

* [Simple example](https://github.com/timotapanainen/terraform-aws-ecs-service/tree/master/example)