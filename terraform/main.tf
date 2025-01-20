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
  ip_range = "10.10.10.0/24"
}

# Create Droplet
resource "digitalocean_droplet" "saleor" {
  name     = "saleor-${var.environment}"
  size     = var.droplet_size
  image    = "ubuntu-20-04-x64"
  region   = var.region
  vpc_uuid = digitalocean_vpc.saleor_network.id
  ssh_keys = [var.ssh_key_fingerprint]

  tags = ["saleor", var.environment]
}

# Create Database
resource "digitalocean_database_cluster" "postgres" {
  name       = "saleor-db-${var.environment}"
  engine     = "pg"
  version    = "13"
  size       = var.db_size
  region     = var.region
  node_count = 1
  vpc_uuid   = digitalocean_vpc.saleor_network.id
}

# Create Redis cluster
resource "digitalocean_database_cluster" "redis" {
  name       = "saleor-redis-${var.environment}"
  engine     = "redis"
  version    = "6"
  size       = var.redis_size
  region     = var.region
  node_count = 1
  vpc_uuid   = digitalocean_vpc.saleor_network.id
}

