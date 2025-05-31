---
created: 2025-05-30T08:03:10+05:30
updated: 2025-05-31T07:15:20+05:30
Maintainer: Ibrar Ansari
---
---

# 🐳 **Day 6: Docker Container restart kill stop rename pause unpause port diff top stats attach Commands - With Examples!**

Welcome to another **Docker tutorial**! Today we dive into **restart kill stop rename pause unpause port diff top stats attach** that every DevOps engineer should know. These tools help you stop, restart, rename, pause, and monitor containers effectively.


## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/FmOOImObJRA/maxresdefault.jpg)](https://youtu.be/FmOOImObJRA)

---

## 📌 1. `Docker start/stop`

Gracefully stops a container (sends **SIGTERM**, then **SIGKILL** after timeout).

```bash
docker stop ubuntu
docker stop alpine ubuntu
docker stop $(docker ps -q)
```

➡️ **Use Case**: Shut down containers safely for maintenance.

## 📌 2. `Docker restart`

Restarts a container (stops and starts it again).

```bash
docker restart ubuntu
docker restart alpine ubuntu
docker restart $(docker ps -q)
docker restart $(docker ps -aq)
````

➡️ **Use Case**: Refresh a container after config changes.

## 📌 3. `Docker kill`

Forcibly stops a container by sending a **SIGKILL**. Not a best practices

```bash
docker kill alpine
docker kill alpine ubuntu
docker kill $(docker ps -q)
```

➡️ **Use Case**: Terminate an unresponsive container immediately.


## 📌 4. `Docker rename`

Renames an existing container.

```bash
docker rename <old_name> <new_name>
docker rename alpine alpine1
docker rename alpine1 alpine
```

➡️ **Use Case**: Give containers meaningful names after creation.

## 📌 5. `Docker pause`

Pauses all processes in a container using **cgroups freezer**.

```bash
docker pause <container_name_or_id>
docker pause alpine
docker pause alpine ubuntu
docker pause $(docker ps -q)
```

➡️ **Use Case**: Temporarily halt CPU processing without stopping the container.

---

## 📌 6. `Docker unpause`

Resumes a paused container.

```bash
docker unpause <container_name_or_id>
docker unpause alpine
docker unpause alpine ubuntu
docker unpause $(docker ps -q)
```

➡️ **Use Case**: Resume a paused container back to normal execution.

## 📌 7. `Docker port`

Displays the **public-facing ports** and their mappings to the container's internal ports.

```bash
docker port <container_name_or_id>
docker port um
```

➡️ **Use Case**: Identify which host ports map to container ports.

## 📌 8. `Docker diff`

Shows changes made to a container’s filesystem since it started.

```bash
docker diff <container_name_or_id>
docker diff alpine
docker diff um
```

➡️ **Use Case**: Inspect what has been added, changed, or deleted. After container creation.

## 📌 9. `Docker top`

Displays the **running processes** inside a container.

```bash
docker top <container_name_or_id>
docker top alpine
```

➡️ **Use Case**: Inspect what’s running in a container like `ps` on Linux.
## 📌 10. `Docker stats`

Live stream of **resource usage** (CPU, memory, network) by containers.

```bash
docker stats
docker stats ubuntu
```

➡️ **Use Case**: Monitor container performance in real-time.
🖥️ **Tip**: Use `docker stats <container_name>` to focus on a specific container.

## 🖥️ 11. `Docker attach`

Connects your terminal to a **running container’s** standard input/output streams of PID 1. It connect to the main process of the container.

```bash
docker attach nd
http://192.168.1.22:8083/
use Ctrl + P + Q to detach
```
➡️ **Use Case**: Interact with a running container as if you're inside it (e.g., for debugging or running commands).

Great question! `docker attach` and `docker exec` are **both used to interact with running containers**, but they serve **different purposes** and behave differently.

---

## 🔗 `Docker attach` vs `Docker exec`

|Feature|`docker attach`|`docker exec`|
|---|---|---|
|**Purpose**|Connect to the main process of the container|Run a new command inside the container|
|**Interaction**|Connects to stdin, stdout, stderr of PID 1|Starts a separate process inside the container|
|**Effect**|Feels like you’re _inside_ the container’s main terminal|Just runs a single command (e.g., `bash`, `top`)|
|**Multiple Sessions**|Not ideal for multiple users (shared terminal)|Safe to use multiple times concurrently|
|**Exit Behavior**|Detaching can stop the container if not run with `-it`|Command ends, container keeps running|
|**Use Case**|Debugging the main app process|Running one-off commands, inspecting container|
|**Detach Option**|Can use `Ctrl + P + Q` to detach|Not needed – just exit the command|

---

### ✅ Example Usages:

**Attach to a container's main process:**

```bash
docker attach my_container
```

**Run a shell inside a container (without stopping the app):**

```bash
docker exec -it my_container bash
```

### 🔥 Tip:

- Use `docker exec` when you want **safe, isolated interaction** (like debugging or running a command).
- Use `docker attach` only if you really need to tap into the **main running process** (e.g., when it’s a shell or logging service).

## ✅ Best Practices

- ✅ Use `docker stop` before `docker kill` for graceful shutdown.
- ✅ Use `docker pause` only for short periods.
- ✅ Monitor containers regularly with `docker stats`.
- ✅ Always name your containers meaningfully (use `docker rename`).

## 🔗 Additional Resources

- 📘 [Docker CLI Docs](https://docs.docker.com/engine/reference/commandline/docker/)
- 🧰 [Docker Container Management Overview](https://docs.docker.com/reference/cli/docker/container/)
- 🐳 [Docker Hub](https://hub.docker.com/)

---

## 💼 Connect with me 👇👇 😊

- 🔥 [**Youtube**](https://www.youtube.com/@DevOpsinAction?sub_confirmation=1)
- ✍ [**Blog**](https://ibraransari.blogspot.com/)
- 💼 [**LinkedIn**](https://www.linkedin.com/in/ansariibrar/)
- 👨‍💻 [**Github**](https://github.com/meibraransari?tab=repositories)
- 💬 [**Telegram**](https://t.me/DevOpsinActionTelegram)
- 🐳 [**Docker**](https://hub.docker.com/u/ibraransaridocker)

---

## ⭐ Hit the Star!

_**If this helped you, please star the repo and share it. Thanks!**_ 🌟

