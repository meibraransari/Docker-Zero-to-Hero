---
created: 2026-05-25T09:03:30+05:30
updated: 2026-05-25T09:25:47+05:30
Maintainer: Ibrar Ansari
---
# 🐳 **Day 3: Mastering `docker run` Command - With examlpes!**

Docker's `run` command is one of the most essential and versatile tools in a developer's container toolbox. Below is a comprehensive list of `docker run` options, examples, and use cases — **perfect for beginners and intermediate Docker users!**

## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/TXIQYO21ais/maxresdefault.jpg)](https://youtu.be/TXIQYO21ais)

---

## 🔹 Abbreviation
```bash
dia = `DevOps in Action`
```

## 🔹 Basic Usage

```bash
# 🏃 Run a container & remove it after execution
docker run --rm ubuntu echo "Hello from container"

# 🖥️ Run and ping a public DNS (Google) from busybox container
docker run --rm busybox ping 8.8.8.8
```

---

## 🔹 Interactive & Detached Modes

```bash
# 🌐 Run nginx demo container (foreground by default)
docker run nginx

# 🧪 Run with interactive terminal
docker run -it ubuntu

# 🔄 Detached (background) + interactive
docker run -itd --name=dia ubuntu:latest /bin/bash

## -i: Keep STDIN open even if not attached.
## -t: Allocate a pseudo-TTY (terminal).
# Runs the container in the foreground, attaching your terminal to the container's shell. You can interact with it directly (e.g., run commands like bash).
# The container stops when you exit the shell (e.g., by typing exit).

## -d: Run container in detached mode (i.e., in the background).
# Includes the -d (detached) flag, which runs the container in the **background**.
# The container starts and runs independently of your terminal. You won't get an interactive shell unless you explicitly attach to it later (e.g., using docker attach or docker exec).

## Key Difference:
# -it: Runs the container in the foreground with an interactive terminal.
# -itd: Runs the container in the background, detached from your terminal.

```

---

## 🔹 Custom Images and Tags

```bash
# 🛠️ network-debug-toolss with specific tag
docker run -it --rm --name=dia ibraransaridocker/network-debug-tools:latest /bin/bash

```

---

## 🔹 Networking Options

```bash
# 🌐 Use a custom network
docker network create dia_network
docker run -it --rm --network=dia_network ubuntu

# 🧷 Custom DNS
docker run -it --name=dia --dns=8.8.8.8 ubuntu:latest /bin/bash
#cat /etc/resolv.conf

# 🧭 Network alias
docker run -it --rm --name=dia --network=dia_network --network-alias=web ibraransaridocker/network-debug-tools /bin/bash
# Inspect the Container alias: docker inspect dia
docker run -it --rm --name=dia1 --network=dia_network --network-alias=db ibraransaridocker/network-debug-tools /bin/bash 
# From the second container, ping the alias: ping web or db

## The --network-alias is helpful when:
#- You're using service discovery among microservices (e.g., web, db, cache) without needing fixed container names or IPs.
#- You want to refer to a container by a specific hostname within a custom Docker network.
```

---

## 🔹 Volume Mounts (Persistent Storage)

```bash
# 💽 Mount volume from host to container
docker run -it --rm --name=dia -p 8080:80 ibraransaridocker/nginx-demo 
docker run -it --rm --name=dia -p 8080:80 -v $(pwd)/html:/usr/share/nginx/html/ nginx 

# 🔒 Read-only volume mount
docker run -itd --name=dia -p 8080:80 -v $(pwd)/html:/usr/share/nginx/html:ro nginx 

# docker exec -it dia bash
# cd /usr/share/nginx/html
# echo "Test" >> index.html

```

---

## 🔹 Environment Variables & User Settings

```bash
# 🌿 Set environment variable
docker run -it --name=dia -e user=devopsinaction ubuntu env
docker run -itd --name=dia -e user=devopsinaction ubuntu /bin/bash
# docker exec -it dia bash
# printenv

# 👤 Run container with specific UID & GID
docker run -it --name=dia -u 1000:1000 ubuntu /bin/bash
# id
```

---

## 🔹 Port Mapping

```bash
docker run -it --rm --name=dia -p 8080:80 ibraransaridocker/nginx-demo 
docker run -it --rm --name=dia -p 8080:80 -p 8081:80 ibraransaridocker/nginx-demo 
docker run -it --rm --name=dia -p 8080:80 -p 8000-8005:8000-8005 ibraransaridocker/nginx-demo 
```

---

## 🔹 Working Directory & Entrypoint

```bash
# 📁 Set working directory to /app
docker run -it --name=dia -w /app node:alpine sh

# 🚪 Override the default entrypoint
docker run -it --name=dia --entrypoint=/bin/sh ubuntu:latest
```

---

## 🔹 Resource Limits

```bash
# 🧠 Limit memory and CPU usage
docker run -it --name=dia --memory="256m" --cpus="1.0" ibraransaridocker/network-debug-tools
docker stats dia
#load test inside container
# apt update
# apt install stress
# stress --cpu 1 --vm 1 --vm-bytes 300M --timeout 30s

```

---

## 🔹 Restart Policies

```bash
# 🔁 Auto-restart container on failure
docker run -dit --name=dia --restart=always nginx

```
## 🔹 Advanced Use Cases

```bash
# ❤️ Set custom hostname
docker run -itd --name=dia --hostname=webserver ubuntu:latest /bin/bash
# docker exec -it dia bash
# hostname
# cat /etc/hostname

# 💉 Add health check
docker run -itd --name=dia --health-cmd="curl --fail http://localhost || exit 1" --health-interval=30s nginx

# 🔍 Share host’s PID namespace
docker run -itd --name=dia --pid=host ubuntu:latest /bin/bash
```

---

## 🔹 Helpful Tips 💡

* Use `--rm` for disposable containers.
* Combine `-itd` for interactive **and** background usage.
* Bind mount volumes (`-v`) for local development.
* Use `--env` or `--env-file` to pass environment variables in bulk.
* Health checks help in container orchestration.

---

## ✅ Most Common Flags Reference (Cheat Sheet)

| Flag                  | Description                  |
| --------------------- | ---------------------------- |
| `-it`                 | Interactive terminal         |
| `--rm`                | Remove after exit            |
| `-d`                  | Run in background (detached) |
| `-p`                  | Port mapping                 |
| `-v`                  | Mount volume                 |
| `--name`              | Set container name           |
| `--env`, `-e`         | Set environment variable     |
| `--network`           | Connect to a custom network  |
| `--cpus` / `--memory` | Set resource limits          |
| `--restart`           | Set restart policy           |
| `--entrypoint`        | Override entry command       |


---

Would you like me to create this as a **Markdown file for GitHub** or as a **YouTube script format** next?


### Happy Dockering! 🐳✨

## 🤝 Contributing

Contributions are welcome! 🙌 If you have suggestions, improvements, or additional examples:
1. Fork this repository. 🍴
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m git commit -m "Add feature: brief description"`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request. 🚀


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