[webservers]
${droplet_ip}

[databases]
${database_host}

[redis]
${redis_host}

[all:vars]
ansible_user=root
ansible_python_interpreter=/usr/bin/python3
# Remove ansible_ssh_private_key_file as we're using DO's SSH key system
ansible_port=22
environment=${environment}

[webservers:vars]
app_port=80
# app_domain=${domain_name}

[databases:vars]
db_name=${database_name}
db_user=${database_user}
db_password=${database_password}
db_port=5432

[redis:vars]
redis_port=6379
redis_password=${redis_password}