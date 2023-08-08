locals {
  enabled = var.enabled
  name    = "${var.name}-${var.environment}%{if var.suffix != ""}-${var.suffix}%{endif}"
}

module "database" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.3.1"

  name                = local.name
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  publicly_accessible = var.publicly_accessible

  autoscaling_enabled      = var.autoscaling_enabled
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  instances                = var.instances

  database_name               = var.database_name
  master_username             = var.master_username
  master_password             = var.master_password
  manage_master_user_password = var.create_random_password

  skip_final_snapshot = var.skip_final_snapshot

  create_db_subnet_group = var.create_db_subnet_group
  vpc_id                 = var.vpc_id
  subnets                = var.subnet_ids
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
}

module "metric_alarm" {
  count   = var.sns_alarm_topic_arn != "" ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "4.3.0"

  alarm_name          = "${local.name} - CPU Usage High"
  alarm_description   = "CPU Usage Exceeds ${var.alarm_cpu_threshold}%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.alarm_cpu_threshold
  period              = 300

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  dimensions = {
    DBClusterIdentifier = "${var.name}-postgresql"
  }

  alarm_actions = [var.sns_alarm_topic_arn]
}
