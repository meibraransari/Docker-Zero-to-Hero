# 🚀 Mastering Docker Volumes Named, Anonimus, Bind Mount and tmpfs | Complete Guide

Welcome to this **complete guide on Docker Volumes**! In this video, we'll go from basics to advanced topics, ensuring you're fully equipped to manage persistent data in Docker. Let's dive in! 🐳💡

## 🐳 What is Docker Volume?

**Docker volumes** are Docker-managed storage mechanisms designed for **persistent data.** They are stored in a part of the host filesystem managed by Docker (typically `/var/lib/docker/volumes/` on Linux) and are the preferred way to persist data in Docker.

---

## 💡 Why Use a Docker Volume?

By default, any data written inside a container is **lost when the container is removed**. Volumes solve this problem by providing a **managed, persistent storage location**.

---

## 🚀 Key Features of Docker Volumes

* 📦 **Persistent** – Data is retained even if the container is deleted.
* 🔄 **Shared/Reusable** – Volumes can be used by multiple containers.
* 🛠️ **Managed by Docker** – Docker takes care of creation, mounting, and lifecycle.
* 🔗 **Decouples Data and Container** – Keeps data independent of container life.
* ⚡ **Performance** – Optimized for container use.

---

## 🧰 Commands and Flags

* `-v` or `--volume`: Specify a volume.
* `--mount`: More explicit, flexible alternative (preferred for clarity).
* `--tmfs`: Mount a temporary in-memory filesystem (tmpfs). Useful for ephemeral data that doesn't persist across reboots.


---

## 🎬 Video Demonstration

[![Watch on Youtube](https://i.ytimg.com/vi/P9p1khwDid0/maxresdefault.jpg)](https://youtu.be/P9p1khwDid0)

---

# 🗂️ Types of Docker Volumes

---

## 1️⃣ Anonymous Volumes

Anonymous volumes are created automatically by Docker when a container is started, and a volume is specified without a specific name. They are often used for temporary or disposable data, as they are not explicitly named and can be challenging to manage outside the context of the container.

* Created without a specific name.
* Docker generates a random name internally.

**Example:**

```bash
docker volume create
or
docker run -v /app/data nginx:alpine
docker volume ls
```

---

## 2️⃣ Named Volumes

 Named volumes are explicitly created and named using the docker volume create command. They provide a way to manage and share data across containers with a user-defined name.

* You define the name.
* Managed by Docker in `/var/lib/docker/volumes/`.

**Example:**

```bash
docker volume create nginx_data
docker run -itd -v nginx_data:/usr/share/nginx/html/ nginx:alpine
or
docker run -itd --volume nginx_data:/usr/share/nginx/html/ nginx:alpine
docker volume ls
```

---

## 3️⃣ Mapped/Host Volumes (a form of Bind Mount)

Host bind mounts involve mounting a specific directory or file from the host machine into the container. Changes made in the container affect the host file system, and vice versa.

* Maps a directory on the **host** to the container.
* Great for sharing data between host and container.
* Can be relative or absolute path
* -v ./path:/container/path is a shorthand for bind mount, easier and quicker.

**Example:**

```bash
docker run -itd -p 80:80 -v ./data:/usr/share/nginx/html/ nginx:alpine
sudo nano ./data/index.html
curl http://localhost
sudo nano ./data/index.html
```

---

## 4️⃣ Bind Mounts (explicit)

Host bind mounts involve mounting a specific directory or file from the host machine into the container. Changes made in the container affect the host file system, and vice versa.

* Uses absolute paths.
* Data is managed **directly** by the host OS.
* Must be absolute path
* --mount type=bind,source=/path,target=/container is more powerful, cleaner, and preferred for scripts or production.

**Example:**

```bash
docker run -itd -p 80:80 --mount type=bind,source=/home/user/data/,target=/usr/share/nginx/html/ nginx:alpine
curl http://localhost
```


### 🔍 Key Differences:

| Feature                 | Mapped Host Volumes (`-v`)         | Bind Mounts (`--mount`)                   |
| ----------------------- | ---------------------------------- | ----------------------------------------- |
| **Syntax**              | Short: `-v ./host:/container`      | Long: `--mount type=bind,...`             |
| **Path type (host)**    | Can be **relative or absolute**    | Must be **absolute**                      |
| **Feature flexibility** | Limited                            | More flexible (supports more options)     |
| **Readability**         | Less explicit                      | More clear and structured                 |
| **Use case**            | Quick, local, simple dev scenarios | Advanced configurations, clarity, control |

---
---

## 5️⃣ tmpfs Mounts

tmpfs mounts allow you to create an in-memory volume that is stored in the host's memory rather than on disk. This type of volume is useful for temporary data that does not need to persist across container restarts.

* Stored in host memory (RAM), not on disk.
* Volatile: Data does not persist after the container stops.
* High-performance: Ideal for fast, temporary data storage. very fast and lightweight storage (faster than other mounts because of in-memory )
* tmpfs mounts in Docker map directly to tmpfs in the Linux kernel. As such, the temporary data may be written to a swap file, and thereby persisted to the filesystem.

**Example:**

```bash
docker run -itd --tmpfs /app nginx:latest
docker run -itd --mount type=tmpfs,destination=/usr/share/nginx/html/ nginx:alpine
or
docker run -itd --mount type=tmpfs,destination=/app/data,tmpfs-size=100m,tmpfs-mode=1770 nginx:alpine
# This mounts a tmpfs volume to /app/data inside the container. All data written to this path will be stored in the host’s RAM.
docker run -d \
  -it \
  --name tmptest \
  --mount type=tmpfs,destination=/app \
  nginx:alpine
docker inspect tmptest --format '{{ json .Mounts }}'
```
* tmpfs-size=100m: Limit RAM usage to 100MB
* tmpfs-mode=1770: Set file permissions (e.g., 1770 for rwxrwx--T)
* Works only on Linux hosts (Windows/macOS Docker Desktop uses a VM).

---

# 🔧 Managing Docker Volumes

---

## 📁 Creating Volumes

```bash
docker volume create data_volume
# If no name specified:
docker volume create
```

---

## 📋 Listing Volumes

```bash
docker volume ls
# 🔍 Filter by name:
docker volume ls -f name=data
```

---

## 🔍 Inspecting Volumes

```bash
docker volume inspect data_volume

# Example Output:
{
  "Name": "data_volume",
  "Mountpoint": "/var/lib/docker/volumes/data_volume/_data",
  ...
}
```

---

## ❌ Removing Volumes

```bash
docker volume rm data_volume
```

---

## 🧹 Pruning Unused Volumes

```bash
docker volume prune
# Prompts: Are you sure you want to continue? [y/N]
```

---

# 🤝 Sharing Volumes with `--volumes-from`

## 🔄 What It Does

Allows one container to **reuse volumes** from another container.

---

### ✅ Example 1: Share Anonymous Volume

```bash
docker run -d --name data-container -v /data busybox sleep 3600
docker run -it --rm --name app-container --volumes-from data-container busybox sh
```

---

### ✅ Example 2: Share Named Volume

```bash
docker volume create shared-vol
docker run -d --name backend -v shared-vol:/var/lib/app busybox sleep 3600
docker run -it --rm --name frontend --volumes-from backend busybox sh
```

---

### ✅ Example 3: Read-Only Volume

```bash
docker run -it --rm --name reader --volumes-from backend:ro busybox sh
```

---

### 🎯 Example Scenarios

```bash
### 🗃️ 1. Persist Database Data
docker run -v my-db-volume:/var/lib/mysql mysql
✅ Data persists across container restarts.

### 👨‍💻 2. Live Code Development
docker run -v /home/user/code:/app my-image
✅ Host file changes reflect immediately in the container.

### 🔒 3. Read-Only Configuration
docker run --mount type=bind,source=/config,target=/app/config,readonly my-image
✅ Ensures configuration files can't be modified by the container.
```
---

### ✅ Best Practices & Recommendations

* ✔️ Use **Volumes** (`--mount type=volume`) for production.
* 🧪 Use **Bind Mounts** for development scenarios.
* 🧾 Prefer `--mount` over `-v` for clarity in scripts.
* ⚠️ Avoid **Bind Mounts** in production due to permission/portability issues.

---

### 🔗 Additional Resources

* 📘 [Docker Volumes](https://docs.docker.com/engine/storage/volumes/)
* 📘 [Docker Bind Mounts](https://docs.docker.com/engine/storage/bind-mounts/)
* 📘 [Docker tmpfs Mounts](https://docs.docker.com/engine/storage/tmpfs/)

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
