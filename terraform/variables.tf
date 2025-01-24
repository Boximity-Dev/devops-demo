# variables.tf
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "environment" {
  description = "Environment (prod/staging)"
  type        = string
  default     = "staging"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "db_size" {
  description = "Database size"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "redis_size" {
  description = "Redis size"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "ssh_key_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the infrastructure"
  type        = string
}
