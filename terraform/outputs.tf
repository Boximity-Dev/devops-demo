# outputs.tf
output "droplet_ip" {
  value = digitalocean_droplet.saleor.ipv4_address
}

output "database_host" {
  value = digitalocean_database_cluster.postgres.host
}

output "redis_host" {
  value = digitalocean_database_cluster.redis.host
}
