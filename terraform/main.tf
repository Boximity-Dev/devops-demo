# main.tf
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}



# Create VPC
resource "digitalocean_vpc" "saleor_network" {
  name     = "saleor-network"
  region   = var.region
  ip_range = "192.168.1.0/24"
}

# Create Droplet
resource "digitalocean_droplet" "saleor" {
  name     = "saleor-${var.environment}"
  size     = var.droplet_size
  image    = "debian-11-x64"
  region   = var.region
  vpc_uuid = digitalocean_vpc.saleor_network.id
  ssh_keys = [var.ssh_key_fingerprint]

  tags = ["saleor", var.environment]
}

# Create firewall
resource "digitalocean_firewall" "saleor" {
  name = "saleor-web"
  droplet_ids = [digitalocean_droplet.saleor.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range           = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range           = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create Database
resource "digitalocean_database_cluster" "postgres" {
  name                 = "saleor-db-${var.environment}"
  engine              = "pg"
  version             = "13"
  size                = var.db_size
  region              = var.region
  node_count          = 1
  private_network_uuid = digitalocean_vpc.saleor_network.id
}

# Create Redis cluster
resource "digitalocean_database_cluster" "redis" {
  name       = "saleor-redis-${var.environment}"
  engine     = "redis"
  version    = "7"
  size       = var.redis_size
  region     = var.region
  node_count = 1
  private_network_uuid = digitalocean_vpc.saleor_network.id
}

# Create project
resource "digitalocean_project" "saleor" {
  name        = "saleor-${var.environment}"
  description = "Saleor e-commerce platform resources for ${var.environment} environment"
  purpose     = "Web Application"
  environment = var.environment
}

# Add resources to project
resource "digitalocean_project_resources" "saleor" {
  project = digitalocean_project.saleor.id
  resources = [
    digitalocean_droplet.saleor.urn,
    digitalocean_database_cluster.postgres.urn,
    digitalocean_database_cluster.redis.urn
  ]
}
