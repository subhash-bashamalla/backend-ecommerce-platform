output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}

output "sg_ecs_id" {
  value = aws_security_group.sg_ecs.id
}

output "sg_db_id" {
  value = aws_security_group.sg_db.id
}

output "sg_redis_id" {
  value = aws_security_group.sg_redis.id
}

output "endpoint_sg_id" {
  value = aws_security_group.endpoints_sg.id
}

output "monitoring_sg_id" {
  value = aws_security_group.monitoring_sg.id
}