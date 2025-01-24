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

# Create Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      # Infrastructure
      droplet_ip     = digitalocean_droplet.saleor.ipv4_address
      database_host  = digitalocean_database_cluster.postgres.host
      redis_host     = digitalocean_database_cluster.redis.host
      
      # Environment
      environment = var.environment
      
      # Application
      # domain_name = var.domain_name
      
      # Database
      database_name = digitalocean_database_cluster.postgres.database
      database_user = digitalocean_database_cluster.postgres.user
      database_password = digitalocean_database_cluster.postgres.password
      
      # Redis
      redis_password = digitalocean_database_cluster.redis.password
    }
  )
  filename = "${path.module}/../ansible/inventory/inventory.ini"
  depends_on = [
    digitalocean_droplet.saleor,
    digitalocean_database_cluster.postgres,
    digitalocean_database_cluster.redis
  ]
}
