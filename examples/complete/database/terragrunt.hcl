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
