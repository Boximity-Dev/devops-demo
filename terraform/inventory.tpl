[webservers]
${droplet_ip}

[databases]
${database_host}

[redis]
${redis_host}

[all:vars]
ansible_user=root
ansible_python_interpreter=/usr/bin/python3