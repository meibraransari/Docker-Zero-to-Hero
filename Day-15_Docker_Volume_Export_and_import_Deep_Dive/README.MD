---
created: 2025-07-03T07:48:31+05:30
updated: 2025-07-07T08:51:43+05:30
Maintainer: Ibrar Ansari
---
# 🐳 Docker Volume Export and Import Deep Dive(Using, CP command, Import/export command, Docker API, SSH and Dotfiles) 🚀
Welcome to this deep dive into **Docker volume export and import**! 🎉 Whether you're a developer, DevOps engineer, or just curious about Docker, this guide will walk you through everything you need to know about managing persistent data in Docker using volumes. We'll cover what volumes are, why exporting and importing them is useful, and provide a hands-on demo to make it crystal clear. Let’s dive in! 

## 🤔Why Export and Import Docker Volumes? 
Exporting and importing volumes is essential for:
- **Backups**: Save volume data to a file for safekeeping. 📦
- **Migration**: Move data to another Docker host or environment.
- **Sharing**: Share volume data with teammates or other systems.
- **Transitioning**: Convert bind mounts to volumes or vice versa for better management.
For example, imagine you’re running a web app with a database in a Docker volume, and you need to move it to a new server. Exporting the volume to a `.tar.gz` file and importing it on the new host ensures your data stays intact. 
### 🛠️ Prepare Docker Containers for the Demo(1. Database, 2. Uptime-kuma, 3. Nginx)
```bash
mkdir day15 && cd day15

# Demo 1: Database Container
docker run -itd --name mariadb -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -v mariadbdata:/var/lib/mysql mariadb:latest
docker logs mariadb | grep 'ready for connections'
docker exec -it mariadb mariadb -uroot -proot
CREATE DATABASE day15;
USE day15;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES
('Docker', 'Docker@example.com'),
('Day15', 'Day15@example.com');

exit

docker exec -it mariadb mariadb -uroot -proot -e "USE day15; SELECT * FROM users;"

# Demo 2: Monitoring Container
docker run -itd -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1
Create user onboarding and add mysql in monitoring

# Demo 3: Web Server Container
docker run -itd --name=nginx  -v nginxdata:/usr/share/nginx/html -p 8080:80 nginx:latest
sudo sh -c 'echo "Welcome to DevOps in Action!" > /var/lib/docker/volumes/nginxdata/_data/index.html'

# List 3 Demo volumes
docker volume ls

# Inspect path for basic understanding
CONTAINER=mariadb
docker container inspect -f '{{json .Mounts}}' $CONTAINER | jq
```

### 💾 Method 1: Backup manual way(using cp command) on the same host (Best for migrate bind mount to volume)

```bash
docker volume create backupvol
sudo ls -alsh /var/lib/docker/volumes/backupvol/_data

sudo ls -alsh /var/lib/docker/volumes/nginxdata/_data
sudo cp -r /var/lib/docker/volumes/nginxdata/_data /var/lib/docker/volumes/backupvol/
sudo ls -alsh /var/lib/docker/volumes/backupvol/_data
Note:- You can copy bind-mount or host data in a volume for backup.
```

### 📦 Method 2: Named Volume (Existing volumes)

```bash
mkdir method2 && cd method2

VOLUME_NAME=mariadbdata
docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -zcvf /backup/my-backup.tar.gz /backup-volume

ls -alsh my-backup.tar.gz

```
### 📁 Method 3: volume-from (For Anonymus and named volume)
```bash
cd .. && mkdir method3 && cd method3
CONTAINER_NAME=uptime-kuma
docker run --rm \
  --volumes-from $CONTAINER_NAME \
  -v "$(pwd)":/backup \
  busybox \
  tar -zcvf /backup/my-backup.tar.gz /app/data

ls -alsh my-backup.tar.gz

Note:- `--volumes-from` shares **all** volumes from a container at their **original mount points**.
```

### 🗑️ Optional: Remove Volumes to Test Import
```bash
Stop and remove the container
docker rm -f $(docker ps -aq)
docker volume rm mariadbdata nginxdata uptime-kuma
docker volume ls
```

### ✅ Method 1 Restore using existing volume manually (Using by CP Command and tar command)
```bash
sudo ls -alsh /var/lib/docker/volumes/backupvol/_data
docker run -itd --name=nginx  -v backupvol:/usr/share/nginx/html -p 8080:80 nginx:latest
http://192.168.1.210:8080/


# Using tar command
docker volume create tarvol
sudo tar xzf my-backup.tar.gz -C /var/lib/docker/volumes/tarvol/_data
sudo ls -alsh  /var/lib/docker/volumes/tarvol/_data/
```

### ✅ Method 2 Restore the backup contents into the volume(Used by Export Command)
```bash
cd .. && cd method2
docker volume create mariadbdata
docker run --rm \
  -v mariadbdata:/backup-volume \
  -v "$(pwd)":/backup \
  busybox \
  tar -zxvf /backup/my-backup.tar.gz -C /


docker run -itd --name mariadb -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -v mariadbdata:/var/lib/mysql mariadb:latest
docker logs mariadb | grep 'ready for connections'
docker exec -it mariadb mariadb -uroot -proot -e "USE day15; SELECT * FROM users;"


# Restore uptime kuma backup on volume(Before container creation)
cd .. && cd method3
docker volume create uptime-kuma
docker run --rm \
  -v uptime-kuma:/app/data \
  -v "$(pwd)":/backup \
  busybox \
  tar -zxvf /backup/my-backup.tar.gz -C /

docker run -itd -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1 

# Restore uptime kuma on running container(After container creation)
CONTAINER_NAME=uptime-kuma
docker run --rm \
  --volumes-from $CONTAINER_NAME \
  -v "$(pwd)":/backup \
  busybox \
  tar -zxvf /backup/my-backup.tar.gz -C /

docker stop uptime-kuma
docker start uptime-kuma
```


### 🔁 Method 3: Restore/Migrate using SSH (For Production Migration Over SSH)
```bash
# Create a tar archive of the contents of the local 'backupvol' volume and stream it over SSH to a remote host, where it's extracted into a volume with the same name

docker run --rm -v backupvol:/data alpine tar -C /data -cf- . | gzip | \
  ssh root@192.168.1.104 "gzip -d | docker run -i -v backupvol_ssh:/data alpine tar -C /data -xf-"

sudo cat /var/lib/docker/volumes/backupvol_ssh/_data/index.html
```

### 🌐 Method 4: Restore/Migrate using Docker API (For Production Migration Over Docker API)
```bash
docker run --rm -v backupvol:/data busybox tar czf - -C /data . | \
docker -H tcp://192.168.1.104:2375 run --rm -i -v backupvol_api:/data busybox tar xzf - -C /data

export DOCKER_HOST="tcp://192.168.1.104:2375"
docker volume ls
env | grep DOCKER_HOST
unset DOCKER_HOST

sudo cat /var/lib/docker/volumes/backupvol_api/_data/index.html
```

### 💡 Bonus Tips: Export and Import Using Dotfiles (💪🏻Power of DevOps Automation)


🎥 **Watch the Complete Video Guide**: [Click here to view on YouTube](https://youtu.be/EumdEnYgI_Q)

```bash
# Create container for the Demo
docker run -itd -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1
Create user onboarding and add mysql in monitoring

# Export Volume Example
volume_export_import export uptime-kuma uptime-kuma.tar.gz
docker volume rm uptime-kuma
docker volume ls

# Import volume Example
volume_export_import import uptime-kuma uptime-kuma.tar.gz
docker volume ls
docker run -itd -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1

# Note:- Used beow commands in above tool
# Export command
CONTAINER_NAME=uptime-kuma
VOLUME_NAME=uptime-kuma-data # Replace with the actual volume name used by uptime-kuma
docker run --rm \
  -v "$VOLUME_NAME":/_data:ro \
  -v "$(pwd)":/backup \
  busybox \
  tar -zcvf /backup/my-backup.tar.gz -C / _data

ls -alsh my-backup.tar.gz

# Import command
VOLUME_NAME=uptime-kuma-data
docker volume create "$VOLUME_NAME" >/dev/null
docker run --rm -i -v "$VOLUME_NAME":/_data:rw busybox tar xzf - -C /_data < "$(pwd)/my-backup.tar.gz"
```

### ✅Best Practices and Tips 🌟

- **Docker image version**: Use always `same docker image version` to restore/import data to avoid any kind of versioning data loss.
- **Use Named Volumes**: Named volumes (e.g., `my-app-volume`) are easier to manage than anonymous volumes.
- **Compress Backups**: Use `.tar.gz` to save space when exporting.
- **Check Container Status**: If a volume is in use, containers may be paused during export/import.
- **Secure Data**: Ensure sensitive data in volumes is encrypted or access-controlled.
- **Automate**: Use scripts or CI/CD pipelines for regular backups.
- **Verify Imports**: Always verify data integrity after importing.
- **SSH for Remote Transfers**: When moving volumes between hosts, ensure SSH is configured for secure transfers.

### 🔗 Additional Resources

* 📘 [Docker Volumes](https://docs.docker.com/engine/storage/volumes/)

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
