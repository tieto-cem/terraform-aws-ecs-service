[![CircleCI](https://circleci.com/gh/tieto-cem/terraform-aws-ecs-service.svg?style=shield&circle-token=25a95fd9f688376110509611a19a6e64c58548b8)](https://circleci.com/gh/tieto-cem/terraform-aws-ecs-service)

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