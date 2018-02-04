
output "name" {
  value = "${coalesce(join("", aws_ecs_service.ecs_service_with_lb.*.name), join("", aws_ecs_service.ecs_service_without_lb.*.name))}"
}