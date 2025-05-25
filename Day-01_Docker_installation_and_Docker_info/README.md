---
created: 2025-05-25T09:03:30+05:30
updated: 2025-05-25T09:25:47+05:30
---

---
# 🚀 Day-1: Docker Installation & Getting Started

Welcome to Day-1 of learning Docker! In this guide, we'll cover how to install Docker, verify the installation, run your first container, and have a little fun with a live web server example. 🎉


## 🔧 Step 1: Install Docker

👉 Official Docs:

- 🌐 Docker Engine (Linux): [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)
- 🖥️ Docker Desktop (Windows): [https://docs.docker.com/desktop/setup/install/windows-install/](https://docs.docker.com/desktop/setup/install/windows-install/)
- 📋 Docker Release Notes: [https://docs.docker.com/desktop/release-notes/](https://docs.docker.com/desktop/release-notes/)

> 💡 After installation, make sure Docker Desktop is running (Windows/macOS), or the Docker daemon is active (Linux).

---

## ✅ Step 2: Verify Installation

Run the following commands in your terminal to ensure Docker is properly installed:

```bash
docker --version                   # ✅ Docker version
docker-compose --version          # ✅ Docker Compose version
docker info                       # ℹ️  General system info
docker info --format '{{.ServerVersion}}'   # 🎯 Server version only
docker info --format '{{.ClientInfo}}'      # 🎯 Client info only
docker info | grep "Docker Root Dir:" # 📁 Find the Docker root directory path
sudo ls -alsh  /var/lib/docker # 📂 List contents of the Docker root directory
total 52K
4.0K drwx--x--- 12 root root 4.0K May 24 23:13 .                # This directory itself
4.0K drwxr-xr-x 74 root root 4.0K May 15 21:42 ..               # Parent directory
4.0K drwx--x--x  4 root root 4.0K Aug 25  2024 buildkit         # 💡 Used for efficient image builds with BuildKit
4.0K drwx--x---  2 root root 4.0K May 24 23:13 containers       # 📦 Stores container metadata and logs
4.0K -rw-------  1 root root   36 Aug 25  2024 engine-id        # 🆔 Unique ID for this Docker engine instance
4.0K drwx------  3 root root 4.0K Aug 25  2024 image            # 🖼️ Stores image metadata and layers
4.0K drwxr-x---  3 root root 4.0K Aug 25  2024 network          # 🌐 Docker network configuration and data
4.0K drwx--x--- 32 root root 4.0K May 24 23:13 overlay2         # 📂 Default storage driver directory (overlay2)
4.0K drwx------  4 root root 4.0K Aug 25  2024 plugins          # 🔌 Installed Docker plugins (e.g. volume or network)
4.0K drwx------  2 root root 4.0K May 24 23:13 runtimes         # ⏱️ Runtime binaries (like runc or containerd)
4.0K drwx------  2 root root 4.0K Aug 25  2024 swarm            # 🐝 Docker Swarm cluster data (if used)
4.0K drwx------  2 root root 4.0K May 24 23:13 tmp              # 🧪 Temporary files used by Docker daemon
4.0K drwx-----x  3 root root 4.0K May 24 23:13 volumes          # 📦 Volume data used by containers

````

````bash
🧠 Summary
| ------------- | --------------------------------------------------------- |
| Folder        | Description                                               |
| ------------- | --------------------------------------------------------- |
| `buildkit/`   | Docker's modern build engine files                        |
| `containers/` | Metadata and runtime logs for each container              |
| `engine-id`   | Unique ID for your Docker engine installation             |
| `image/`      | Metadata and layers for container images                  |
| `network/`    | Network config (bridge, host, etc.)                       |
| `overlay2/`   | Union file system used by Docker to store container files |
| `plugins/`    | Installed plugins                                         |
| `runtimes/`   | Container runtime definitions (e.g., `runc`)              |
| `swarm/`      | Swarm mode cluster information                            |
| `tmp/`        | Temporary working data                                    |
| `volumes/`    | Persistent volumes mounted into containers                |
| ------------- | --------------------------------------------------------- |
````

### 🐧 For Linux users only:

```bash
sudo systemctl status docker      # 🔍 Check Docker daemon status
sudo journalctl -u docker         # 📜 Docker logs
```

---

## 🧪 Step 3: Test Docker

Run a test container to verify everything works:

```bash
docker run hello-world            # 🚀 Runs a simple test container
docker ps                         # 📋 List running containers
docker ps -a                      # 📋 List all containers (including stopped)
docker images                     # 🗂️  List downloaded images
```

---

## 🎉 Step 4: Fun Example – Run NGINX Web Server

```bash
docker pull nginx                 # ⬇️ Pull the latest NGINX image
docker run -d -p 8080:80 nginx    # 🌐 Start web server on localhost:8080
```

🖥️ Open your browser and go to: [http://localhost:8080](http://localhost:8080) or use IP, in my case [http://192.168.1.22:8080](http://192.168.1.22:8080)

> You’ll see the default NGINX welcome page served from inside a Docker container!

---

## 🧹 Step 5: Clean Up Docker Resources

```bash
docker system df                  # 📊 View disk usage
docker system prune               # 🧼 Clean up unused containers, networks, images
```

> ⚠️ `docker system prune` will prompt you before deletion. Make sure you don’t need any data it will remove!

---

## 📝 Summary

| Command                          | Description              |
| -------------------------------- | ------------------------ |
| `docker --version`               | Show Docker version      |
| `docker run hello-world`         | Test Docker setup        |
| `docker pull nginx`              | Download the NGINX image |
| `docker run -d -p 8080:80 nginx` | Start NGINX container    |
| `docker system prune`            | Remove unused data       |

---

📌 **Next up**: Learn how to run your Docker containers like a pro. 💪

---

👋 Happy Dockering!

Made with ❤️ for Day-1 learners.


## 🤝 Contributing

Contributions are most welcome. Ensure commits use conventional commits.
### 💼 Connect with me 👇👇 😊

- 🔥 [**Youtube**](https://www.youtube.com/@DevOpsinAction?sub_confirmation=1)
- ✍ [**Blog**](https://ibraransari.blogspot.com/)
- 💼 [**LinkedIn**](https://www.linkedin.com/in/ansariibrar/)
- 👨‍💻 [**Github**](https://github.com/meibraransari?tab=repositories)
- 💬 [**Telegram**](https://t.me/DevOpsinActionTelegram)
- 🐳 [**Docker**](https://hub.docker.com/u/ibraransaridocker)

# Hit the Star! ⭐
***If you are planning to use this repo for learning, please hit the star. Thanks!***
****