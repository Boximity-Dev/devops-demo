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
      droplet_ip     = digitalocean_droplet.saleor.ipv4_address
      database_host  = digitalocean_database_cluster.postgres.host
      redis_host     = digitalocean_database_cluster.redis.host
    }
  )
  filename = "${path.module}/../ansible/inventory/inventory.ini"
  depends_on = [
    digitalocean_droplet.saleor,
    digitalocean_database_cluster.postgres,
    digitalocean_database_cluster.redis
  ]
}
