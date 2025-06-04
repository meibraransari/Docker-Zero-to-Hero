
# 🚢 Docker Export/Import & Save/Load Guide

Welcome to this hands-on guide for **Exporting, Importing, Saving, and Loading Docker Containers and Images**. Perfect for backups, sharing, or migrating environments! 🎯

## 🐳 Docker Image & Container Management Commands Summary

- 🛬 **`docker import`** – Creates an image from a tarball (e.g., from `docker export`).
- 📦 **`docker load`** – Loads an image from a tar archive (e.g., from `docker save`).
- 🛫 **`docker export`** – Exports a container’s filesystem as a tar archive.
- 💾 **`docker save`** – Saves one or more images to a tar archive.
- 📝 **`docker commit`** – Creates a new image from a container’s changes.

---
<!--
## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/PcIa46zrpmU/maxresdefault.jpg)](https://youtu.be/PcIa46zrpmU)
-->

## ⚖️ Comparison: `docker export` vs `docker save` vs `docker commit`

| Feature                       | `docker export`              | `docker save`             | `docker commit`                                        |
| ----------------------------- | ---------------------------- | ------------------------- | ------------------------------------------------------ |
| Operates on                   | **Containers**               | **Images**                | **Containers**                                         |
| Includes image history        | ❌ No                         | ✅ Yes                     | ❌ No (new image has no prior history)                  |
| Includes environment metadata | ❌ No                         | ✅ Yes                     | ✅ Partial (CMD, ENV if set in container or base image) |
| Volume data                   | ❌ Not included               | ❌ Not included            | ❌ Not included                                         |
| Layered image                 | ❌ No (flattened)             | ✅ Yes                     | ✅ New image layer added                                |
| Output                        | Container filesystem archive | Full Docker image archive | Docker image (tagged)                                  |
| Typical use                   | Share/backup container FS    | Backup/share full image   | Capture container state as image                       |

## ⚖️ Difference Between `docker import` vs `docker load`

| Feature                     | `docker import`                            | `docker load`                            |
| --------------------------- | ------------------------------------------ | ---------------------------------------- |
| 📦 Input Type               | **Container filesystem archive** (`.tar`)  | **Docker image archive** (`.tar`)        |
| 📚 Metadata (e.g. CMD, ENV) | ❌ Not preserved                            | ✅ Fully preserved                        |
| 🏷️ Tags Image?             | Optional in command                        | Uses tags from saved image               |
| 🧱 Layers Retained          | ❌ No (flattened image, no layers/history)  | ✅ Yes (preserves image layers)           |
| 🔁 Use Case                 | Rebuild image from exported **container**  | Restore image saved with `docker save`   |
| 🔧 Common Usage             | Backup/migrate containers, minimal rebuild | Full image backup/restore across systems |

## 🧠 TL;DR

* Use docker **import**` if you have an exported **container filesystem** (`export`).
* Use `docker **load**` if you have a saved **image archive** (`save`).
* Use `docker **commit**` if you want to turn a **live container into a new image**, preserving its current state.


## 🔧 Prepare Environment for the Demo

```bash
# Run Day 08 Container for demo
DAY=day09
mkdir -p $DAY && cd $DAY 
echo "Welcome to DevOps in Action" | sudo tee ./index.html
docker run -itd --name=$DAY -p 8085:80 -v /home/user/$DAY:/usr/share/nginx/html nginx:alpine
http://192.168.1.22:8085/

# Example container ID or name
container_name="day09"
or 
container_name="d40fa919ae31"
```

## 📦 1. Exporting and Importing Containers

```bash
## 🔹 Export a Running or Paused Container
# You can export a container's filesystem into a `.tar` archive.
docker export $container_name | gzip > $container_name.tgz
# 📝 This only includes the filesystem, not image layers or history.

## 🔹 Import an Exported Container
gunzip -c $container_name.tgz | docker import - mynewimage:latest
docker image history mynewimage
# > 🔁 This creates a new image from the tarball, useful for backups or transferring containers.
# Test image
docker run -itd --name=testimage -p 8090:80 mynewimage:latest
# you got error here so see above table for understanding.
# 📚 Metadata (e.g. CMD, ENV) ❌ Not preserved

## 🔹 Commit a Container to Preserve State with Metadata
docker commit -a "Ansari" $container_name preserve:v1
docker image history preserve:v1
# 📝 This creates a new image named 'preserve:v1' from the current state of the container.
#     - Includes the current filesystem state
#     - Retains metadata like CMD, ENV if the base image had it
#     - Useful for turning a modified container into a reusable image

## 🔹 Run a Container from the Committed Image
docker run -itd --name=testimage -p 8090:80 preserve:v1
docker logs testimage
http://192.168.1.22:8090/

# 🟢 This runs a container from the newly committed image.
```

## 🧊 2. Saving and Loading Docker Images
```bash
## 🔹 Save Docker Image to `.tar`
docker save -o ubuntu_latest.tar ubuntu:latest
ls -alsh ubuntu*
# Or compressed:
docker save ubuntu:latest | gzip > ubuntu_latest.tar.gz
du -sh ubuntu*

## 🔹 Load Docker Image from `.tar`
docker image remove ubuntu:latest
docker images | grep ubuntu

docker load -i ubuntu_latest.tar
docker images | grep ubuntu
# Or for `.gz`:
docker image remove ubuntu:latest
docker load < ubuntu_latest.tar.gz
docker images | grep ubuntu

docker image history ubuntu
```
## 🔍 Visual Analogy

| Action          | Analogy                              |
| --------------- | ------------------------------------ |
| `docker import` | 📸 Taking a **photo** of a container |
| `docker load`   | 🧬 Cloning the **entire image DNA**  |

## ⚙️ 3. Exporting All Stopped Containers

Let’s export all **exited containers** with their names and IDs.


```bash
# First clean folder
rm -rf *

# Make a stopped container
docker stop $container_name

# Run hello world
docker run hello-world

# Exporting All Stopped Containers
while read image container_id; do
  image_sanitized=$(echo "$image" | tr '/:' '_') # handles slashes and tags
  docker export "$container_id" > "${image_sanitized}-${container_id}.tar"
done < <(docker ps -a -f status=exited --format '{{.Image}} {{.ID}}')
```

---

## 🚀 4. Import Containers as Versioned Images

To convert exported containers into images with version tags:

```bash
for file in *.tar; do
  base=$(basename "$file" .tar)
  # e.g., "hello-world-53af1e9021bf"
  image_name="${base%-*}"      # remove the last dash + ID
  # container_id="${base##*-}"   # extract only the container ID
  # Optional: replace underscores back to slashes/colons if needed
  # image_name=$(echo "$image_name" | tr '_' '/')
  # docker import "$file" "${image_name}:${container_id}"
  docker import "$file" "${image_name}:latest"
done

```


---

## 🏷️ 5. Save All Images to `.tar`

Want to back up **all images**?

```bash
# First clean folder
rm -rf *

# Save All Images to `.tar`
docker save $(docker images | sed '1d' | awk '{print $1 ":" $2 }') -o allinone.tar

# To avoid malformed names dangling images if you have:
docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>" | xargs docker save -o allinone.tar

# Export it seprately
docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>" | while read image; do
  filename=$(echo "$image" | sed 's/[\/:]/_/g').tar
  docker save "$image" -o "$filename"
done

```

---
## 📤 6. Load All Saved Images

Load every `.tar` file in the current directory:

```bash
# Stop all containers
docker rm -f $(docker ps -aq)

# Remove all images
docker rmi -f $(docker images -q)

# Load Saved Images
docker load -i allinone.tar

# Load All Saved Images seprately
for tarfile in *.tar; do
  echo "Loading $tarfile..."
  docker load -i "$tarfile"
done

# Verify it
docker images

# Test image
docker run -itd --name=test -p 8080:80 nginx:alpine

# Test Nginx
http://192.168.1.22:8080/
```

## 🛠️ 7. Troubleshooting
- **Error: No such container**:
  - Ensure the container exists (`docker ps -a`).
- **Error: Invalid tar header**:
  - Verify the tarball isn’t corrupted (`tar -tvf file.tar`).
- **Large tarball sizes**:
  - Use compression (`gzip`) or clean up unnecessary container data.
- **Imported image not running**:
  - Check if the image requires specific entrypoint/cmd (`docker inspect`).


## 💡 Best Practices & Tips

| Tip 🧠                  | Description                                                           |
| ----------------------- | --------------------------------------------------------------------- |
| Use compression         | Always gzip large exports to save space                               |
| Tag wisely              | Use clear names & tags for imported images                            |
| Automate backups        | Use cron or scripts to automate periodic saves                        |
| Combine with registries | For team environments, push to private Docker registries instead      |
| Verify after import     | Use `docker run -it <image> /bin/bash` to inspect restored containers |

---

## 🔗 Additional Resources

- 📘 [Docker Documentation: Export](https://docs.docker.com/engine/reference/commandline/export/)
- 📘 [Docker Documentation: Import](https://docs.docker.com/engine/reference/commandline/import/)
- 📘 [Docker Documentation: Save](https://docs.docker.com/engine/reference/commandline/save/)
- 📘 [Docker Documentation: Load](https://docs.docker.com/engine/reference/commandline/load/)
- 📘 [Docker Documentation: Commit](https://docs.docker.com/reference/cli/docker/container/commit/)


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

