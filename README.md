<!-- BEGIN_TF_DOCS -->
# terraform-aws-rds-aurora

Terraform module which creates AWS RDS Aurora resources.

## Usage

### Basic

```hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//."
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id                      = "vpc-1234567890"
    private_subnets_cidr_blocks = ["0.0.0.0/0"]
    database_subnet_group_name  = "dt-pg-subnet-group"
    database_subnets            = ["subnet-1234567890", "subnet-0987654321"]
    default_security_group_id   = "sg-1234567890"
  }
}

inputs = {
  name        = "test-pg"
  region      = "us-east-2"
  environment = "test"

  engine         = "aurora-postgresql"
  engine_version = "14.6"
  instance_class = "db.t4g.medium"

  name            = "pg-aurora"
  database_name   = "testexample"
  master_username = "test"

  create_db_subnet_group  = false
  skip_final_snapshot     = true
  db_subnet_group_name    = dependency.network.outputs.database_subnet_group_name
  vpc_id                  = dependency.network.outputs.vpc_id
  subnet_ids              = dependency.network.outputs.database_subnets
  allowed_security_groups = [dependency.network.outputs.default_security_group_id]

  storage_encrypted       = true
  backup_retention_period = 7

  publicly_accessible = true

  #enabled_cloudwatch_logs_exports = ["general"]

  copy_tags_to_snapshot = true

  tags = {
    "CreatedBy" = "Terraform"
    "Company"   = "DeveloperTown"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.7.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_cpu_threshold"></a> [alarm\_cpu\_threshold](#input\_alarm\_cpu\_threshold) | CPU Percentage that should cause an alarm if the actual cpu average is greater than or equal for 300 seconds | `number` | `90` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | If autoscaling should be enabled | `bool` | `false` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | The maximum number of read replicas permitted when autoscaling is enabled | `number` | `2` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | The minimum number of read replicas permitted when autoscaling is enabled | `number` | `1` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to retain backups | `number` | `7` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block allowed to access the database | `string` | `""` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | If a DB subnet group should be created | `bool` | `true` | no |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | If a random password should be generated | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database to create when the DB instance is created | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | The name of the DB subnet group to use for the DB instance | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version of Aurora PostgreSQL. Updating this argument results in an outage | `string` | `"14.3"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance type to use at master instance. This will be the same instance class used on instances created by autoscaling | `string` | `"db.t3.medium"` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map of cluster instances and any specific/overriding attributes to be created | `any` | <pre>{<br>  "one": {}<br>}</pre> | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Required unless `manage_master_user_password` is set to `true` or unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user. Required unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `"ecs-cluster"` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | If the DB instance should have a public access | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the resources will be created | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the role that will be assumed to create the resources in this module | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted | `bool` | `false` | no |
| <a name="input_sns_alarm_topic_arn"></a> [sns\_alarm\_topic\_arn](#input\_sns\_alarm\_topic\_arn) | The SNS Topic ARN to use for Cloudwatch Alarms | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs used by database | `list(string)` | `[]` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix to be added to the name of each resource | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'Unit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where to create database cluster and security groups | `string` | `""` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security group IDs to allow access to the database | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_database_name"></a> [cluster\_database\_name](#output\_cluster\_database\_name) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_master_password"></a> [cluster\_master\_password](#output\_cluster\_master\_password) | n/a |
| <a name="output_cluster_master_username"></a> [cluster\_master\_username](#output\_cluster\_master\_username) | n/a |
| <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port) | n/a |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | n/a |
<!-- END_TF_DOCS -->