output "cluster_endpoint" {
  value = one(module.database[*].cluster_endpoint)
}

output "cluster_port" {
  value = one(module.database[*].cluster_port)
}

output "cluster_reader_endpoint" {
  value = one(module.database[*].cluster_reader_endpoint)
}

output "cluster_master_username" {
  value     = one(module.database[*].cluster_master_username)
  sensitive = true
}

output "cluster_master_password" {
  value     = one(module.database[*].cluster_master_password)
  sensitive = true
}

output "cluster_database_name" {
  value = one(module.database[*].cluster_database_name)
}