variable "instance_class" {
  type        = string
  description = "Instance type to use at master instance. This will be the same instance class used on instances created by autoscaling"
  default     = "db.t3.medium"
}

variable "db_subnet_group_name" {
  type        = string
  description = "The name of the DB subnet group to use for the DB instance"
  default     = ""
}

variable "engine" {
  type        = string
  description = "The database engine to use"
  default     = "aurora-postgresql"
}

variable "engine_version" {
  type        = string
  description = "The version of Aurora PostgreSQL. Updating this argument results in an outage"
  default     = "14.3"
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "The minimum number of read replicas permitted when autoscaling is enabled"
  default     = 1
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "The maximum number of read replicas permitted when autoscaling is enabled"
  default     = 2
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block allowed to access the database"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where to create database cluster and security groups"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs used by database"
  default     = []
}

variable "sns_alarm_topic_arn" {
  type        = string
  description = "The SNS Topic ARN to use for Cloudwatch Alarms"
  default     = ""
}

variable "alarm_cpu_threshold" {
  type        = number
  description = "CPU Percentage that should cause an alarm if the actual cpu average is greater than or equal for 300 seconds"
  default     = 90
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to allow access to the database"
  default     = []
}

variable "publicly_accessible" {
  type        = bool
  description = "If the DB instance should have a public access"
  default     = false
}

variable "autoscaling_enabled" {
  type        = bool
  description = "If autoscaling should be enabled"
  default     = false
}

variable "instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default = {
    one = {}
  }
}

variable "create_random_password" {
  type        = bool
  description = "If a random password should be generated"
  default     = true
}

variable "create_db_subnet_group" {
  type        = bool
  description = "If a DB subnet group should be created"
  default     = true
}

variable "database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
  default     = ""
}

variable "master_username" {
  description = "Username for the master DB user. Required unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database"
  type        = string
  default     = null
}

variable "master_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Required unless `manage_master_user_password` is set to `true` or unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = false
}