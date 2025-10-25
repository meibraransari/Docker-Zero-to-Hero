# Mastering Docker Compose ⚔ | Docker Compose Zero To Hero 🐳

## ⚙️ What is Docker Compose?

**Docker Compose** is a powerful tool that simplifies managing **multi-container Docker applications**.  
Instead of running multiple `docker run` commands manually, you define all your services (like frontend, backend, and database) in a **single YAML file** and launch them together.  

👉 With just one command:
```bash
docker-compose up -d
````
You can spin up an entire application stack!

---
### **Disadvantages of Docker Run Command.**

- 🧩 **Harder to Manage Multi-Container Applications** – You must manually start and link each container individually.
- ⚙️ **No Central Configuration** – All options must be specified in every command instead of a shared config file.  
- 🔁 **Difficult to Reproduce and Maintain** – Recreating setups requires retyping or scripting long commands.  
- 🧠 **Limited Environment Variable and Network Management** – Manual setup is needed for networking and environment sharing.  
- 🪣 **No Built-In Service Dependencies** – There’s no native way to define or control container startup order.  
- 🧹 **Harder Cleanup** – Stopping and removing multiple containers must be done one by one.  
- 📈 **Limited Scalability** – Scaling services requires running and managing multiple commands manually.

---
## 🧩 Core Components of Docker Compose

Docker Compose revolves around three main building blocks:

- 🧱 1. Services: A **service** represents a container. You define them in `docker-compose.yml` or  `ompose.yml` — specifying the **image**, **build context**, **ports**, **environment variables**, and more.
- 🌐 2. Networks: Compose automatically creates a **default network** so services can talk to each other using container names.
You can also define **custom networks** for better isolation or organization.
- 💾 3. Volumes: To **persist data** (like database files), Compose allows you to create and mount **volumes** easily — ensuring your data survives container restarts.

---
## 🌟 Why Use Docker Compose?

- 🔧 **Simplified Control:** Define, configure, and manage multiple services in a single YAML file — no complex orchestration commands needed.
- 👥 **Efficient Collaboration:** Easily share your `docker-compose.yml` file with your team — ensuring everyone runs the same setup.
- ⚡ **Rapid Development:** Compose **reuses existing containers** when no changes are made — making restarts super fast during development.
- 🌍 **Portability Across Environments:** Use environment variables to customize configurations for **development**, **staging**, and **production** effortlessly.
- 💬 **Strong Community Support:** With a large community and extensive documentation, you’ll find countless tutorials, examples, and troubleshooting help online.

---

## 🚀 Docker Compose Benefits

- ✅ Fast and easy configuration with **YAML scripts**
- ✅ **Single-host** deployment made simple
- ✅ Boosted **developer productivity**
- ✅ Enhanced **security** through isolated containers

---

## 🧰 Prerequisites
Before using Docker Compose, make sure Docker and Compose are installed 👇

- 🐋 Install Docker: 🔗 [Docker Engine Installation Guide](https://docs.docker.com/engine/install/)
- 📦 Install Docker Compose: 🔗 [Docker Compose Releases](https://github.com/docker/compose/releases)
- 📦 Run the following commands to install Docker manually:

```bash
cd /tmp && curl -fsSL https://get.docker.com -o get-docker.sh
sudo bash get-docker.sh
sudo usermod $(whoami) -G docker -a
```

- 📦 Run the following commands to install Compose manually:

```bash
#!/bin/bash
compose_version=$(curl https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
output='/usr/local/bin/docker-compose'
sudo curl -L https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m) -o $output
sudo chmod +x $output
sudo cp -a /usr/local/bin/docker-compose /usr/bin/docker-compose
echo $(docker-compose --version)
# Install plugins
sudo apt-get install docker-compose-plugin
# Test the installation.
docker compose version
```

---
## 🧾 Versions of Docker Compose **(Obsoleted)**
In older Compose files, the **version field** specified the format version — like `"2"`, `"2.4"`, `"3"`, or `"3.9"`.

| Version | Description                                         |
| ------- | --------------------------------------------------- |
| **2.x** | Added support for networks and volumes.             |
| **2.4** | Added condition control for dependencies.           |
| **3.x** | Designed for Swarm mode and advanced orchestration. |
| **3.9** | Latest legacy format supporting Compose V2.         |

📝 **Note:** Docker Compose version is 🕰️ _obsolete_ and will ❌ **not be available for future use**.
- 🔗 [Conversion Matrix](https://kompose.io/conversion/)
- 🔗 [Legacy Compose File Versions](https://docs.docker.com/reference/compose-file/legacy-versions/)

---
## 💡 Docker Compose Examples

🚀 **Docker Compose Multi-Examples** – Practice Makes Perfect! 💻🛠️  
⚡ Experiment, build, and conquer multi-container setups like a **true master**! 🏆🖥️


🐳 Docker Compose Examples – Step by Step Practice

Each example has a **unique YAML file name** (`demo1.yaml`, `demo2.yaml`, …).  
Use the corresponding command to run it:

```bash
docker compose -f <filename> up -d
```

```yaml
# Mimimal
services:
  web:
    image: nginx:latest
```


```yaml
# Mimimal+(Add additional things)
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
```

```yaml
# Mimimal With Build
#Dockerfile
FROM nginx:latest
RUN echo "alias ll='ls -alsh --color=auto'" >> /etc/bash.bashrc
RUN apt-get update && \
    apt-get install -y htop iputils-ping net-tools dnsutils traceroute && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 80

# Compose.yaml
services:
  web:
    build:
      context: ./
      dockerfile: Dockerfile
    image: my-nginx:latest   # <— This sets the name/tag for the built image
    container_name: nginx # <— This sets the container’s name
    working_dir: /code
    ports:
      - "8080:80"
    volumes:
      - .:/code

# Build command
docker compose up --build
docker compose up -d --build
docker compose -f ./build_compose.yaml up -d --build
```


```yaml
# Mimimal+++(Add volumes)
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - web_data:/usr/share/nginx/html

volumes:
  web_data:
```

```yaml
# Mimimal+++(Add Network)
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    networks:
      - webnet

networks:
  webnet:
    driver: bridge
```

```yaml
# Intermediate (Add volumes + Network)
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - web_data:/usr/share/nginx/html
    networks:
      - webnet

volumes:
  web_data:

networks:
  webnet:
    driver: bridge
```

```yaml
# Advance 
.env_db
# PostgreSQL credentials
POSTGRES_USER=user
POSTGRES_PASSWORD=pass

# .env
COMPOSE_PROJECT_NAME=nginx_project
DOCKER_VOLUME_STORAGE=''
#NGINX_DEFAULT_CONF=''
TIMEZONE='Asia/Kolkata'

# Compose file
# Define defaults using YAML anchor
x-defaults: &defaults
  restart: unless-stopped
  logging:
    driver: local
    options:
      max-size: "10m"
      max-file: "3"

services:
  db:
    <<: *defaults
    image: postgres:alpine
    container_name: db
    env_file:
      - .env_db
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      nginx:
        aliases:
          - db.internal

  nginx:
    <<: *defaults
    image: my-nginx:latest
    container_name: nginx
    platform: linux/amd64  # For Apple M1 chips
    hostname: nginx
    working_dir: /usr/share/nginx/html
    depends_on:
      db:
        condition: service_healthy
    profiles:
      - ''
      - nginx
    networks:
      nginx:
        aliases:
          - web.internal
    #network_mode: host
    ports:
      - "8080:80" # Host port:Container port
    expose:
      - 80
    dns:
      - 8.8.8.8
    # Add nginx.conf and index.html manually or comment volume section.
    # volumes:
    #   - nginx_html:/usr/share/nginx/html
    volumes:
#      - ${DOCKER_VOLUME_STORAGE:-/mnt/docker-volumes}/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ${DOCKER_VOLUME_STORAGE:-/mnt/docker-volumes}/nginx/html:/usr/share/nginx/html
#      - ${NGINX_DEFAULT_CONF:-./nginx/default.conf}:/etc/nginx/conf.d/default.conf
#      - ${NGINX_SSL_CERT:-./certs/self_signed_cert.pem}:/etc/nginx/ssl/server.crt # uncomment for SSL
#      - ${NGINX_SSL_KEY:-./certs/self_signed_key.pem}:/etc/nginx/ssl/server.key   # uncomment for SSL
    environment:
      - TZ=${TIMEZONE}
      - NGINX_HOST=example.com
      - NGINX_PORT=80
    # Add extra host for Docker Desktop compatibility
    extra_hosts:
      - "host.docker.internal:host-gateway"
      - "api.local:192.168.1.11"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 30s
    deploy:
      resources:
        limits:
          cpus: '0.5' # Limit to 50% of a CPU
          memory: 512M # Limit to 512MB of RAM
        reservations:
          cpus: '0.2' # Reserve 20% of a CPU
          memory: 256M # Reserve 256MB of RAM
    logging:
      driver: json-file
      options:
        max-size: "10m" # Limit log file size
        max-file: "3" # Keep a maximum of 3 log files
    # Annotations: used to identify service or its purpose or service discovery(Traefik, Docker Swarm, or Portainer) and routing and sometime query using Docker’s API.
    labels:
      version: "latest"
      description: "Deployed on 26-10-2025"
      project: frontend
      environment: production
      service.role: "reverse-proxy"
networks:
  nginx:
    driver: bridge
    name: nginx
    labels:
      - "purpose=frontend-network"
volumes:
  nginx_html:
```


```bash
# Commands
docker compose config
docker compose up -d
docker compose -f ./full_compose.yaml up -d
docker compose --profile nginx up -d

dec nginx
htop
ping db.internal
ping web.internal
traceroute db.internal
exit

docker compose down
```
---
## 💎 Awesome Docker Compose Resources 📚 Which Makes you Master ⚔

You can find tons of real-world examples here 👇
- 🔗 [Compose Specification Website](https://compose-spec.io/)
- 🔗 [Docker Compose Documentation](https://docs.docker.com/compose/)
- 🔗 [The Compose Specification](https://github.com/compose-spec/compose-spec/blob/main/spec.md)
- 🔗 [Awesome Docker Compose Github](https://github.com/docker/awesome-compose)
- 🔗 [Awesome Docker Compose Website](https://awesome-docker-compose.com/apps)
- 🔗 [GitHub: ruanbekker/awesome-docker-compose](https://github.com/ruanbekker/awesome-docker-compose)
- 🔗 [GitHub: Haxxnet/Compose-Examples](https://github.com/Haxxnet/Compose-Examples)

---

## 🔁 Convert Docker Run ➜ Docker Compose File

Easily convert `docker run` commands to Compose files using:

- 🔗 [it-tools.tech Converter](https://it-tools.tech/docker-run-to-docker-compose-converter)
- 🔗 [Composerize](https://www.composerize.com/)

Example:

```bash
docker run -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --restart always --log-opt max-size=1g nginx
https://github.com/meibraransari/ftp-server
```

---

## 🛠️ Essential Docker Compose Commands

| Command                  | Description                                    |
| ------------------------ | ---------------------------------------------- |
| `docker-compose up -d`   | Start all services.                            |
| `docker-compose down`    | Stop and remove containers, networks, volumes. |
| `docker-compose ps`      | List running services.                         |
| `docker-compose logs`    | View logs of all services.                     |
| `docker-compose build`   | Build or rebuild services.                     |
| `docker-compose restart` | Restart all services.                          |
| `docker-compose config`  | Validate and view the full configuration.      |

---

## 🧭 Best Practices

- ✅ Keep services **modular and independent**
- ✅ Use **.env files** for secrets and configs
- ✅ Always pin **specific image versions**
- ✅ Use **volumes** for persistent data
- ✅ Commit your `docker-compose.yml` file to version control
- ✅ Use **healthchecks** to monitor service readiness


---

## 🎯 Final Thoughts

Docker Compose is your **gateway to mastering container orchestration**.
With just one YAML file, you can **build, manage, and scale** complex applications easily.

💬 **Learn it. Master it. Automate everything!**

🐳 *Happy Dockering!* ⚓

---

### 💼 Connect with Me 👇😊

* 🔥 [**YouTube**](https://www.youtube.com/@DevOpsinAction?sub_confirmation=1)
* ✍️ [**Blog**](https://ibraransari.blogspot.com/)
* 💼 [**LinkedIn**](https://www.linkedin.com/in/ansariibrar/)
* 👨‍💻 [**GitHub**](https://github.com/meibraransari?tab=repositories)
* 💬 [**Telegram**](https://t.me/DevOpsinActionTelegram)
* 🐳 [**Docker Hub**](https://hub.docker.com/u/ibraransaridocker)

---

### ⭐ If You Found This Helpful...

***Please star the repo and share it! Thanks a lot!*** 🌟




