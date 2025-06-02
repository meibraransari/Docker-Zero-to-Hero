# 🚀 Day 08: Copy Files between Host and Docker Containers 🐳  
**Docker Zero to Hero Series - Copying Like a Pro**

Welcome to Day 08 of our **Docker Zero to Hero 🐳** series!  
Today we’re diving into how to **copy files** **⬅️ From Docker Container to Host** and **➡️ From Host to Docker Container**.

Let’s break it down step-by-step with examples for:

✅ Single files  
✅ Multiple files and directories  
✅ Using `docker cp`  
✅ Using `docker exec`  
✅ Exporting config from a temp container  
✅ Advanced tricks & troubleshooting  


## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/PcIa46zrpmU/maxresdefault.jpg)](https://youtu.be/PcIa46zrpmU)


## 🔧 Set Example Container Name

```bash
# Run Day 08 Container for demo
docker run -itd --name=day08 -p 8085:80 -v /home/user/html:/usr/share/nginx/html nginx:latest
mkdir -p day08

# Example container ID or name
container_name="day08"
or 
container_name="d40fa919ae31"
```

## 🧱 1. Copying Files using `docker cp` (Simple & Powerful)

### 📥 Copy from Container ➡️ to Host

```bash
# Inspect container path/colume/bind-mount
docker inspect $container_name | jq '.[0].Mounts[] | select(.Type == "bind" or .Type == "volume") | {Type, Source, Destination}'

# Single file
docker cp $container_name:/path/in/container/file.txt /path/on/host/file.txt

# Example:
mkdir -p /home/user/html_file
docker cp $container_name:/usr/share/nginx/html/index.html /home/user/html_file/index.html
cat /home/user/html_file/index.html

# Directory (recursively)
docker cp $container_name:/usr/share/nginx/html /home/user/html_backup
ls -alsh /home/user/html_backup
````



### 📤 Copy from Host ➡️ to Container

```bash
# Single file
docker cp /path/on/host/file.txt $container_name:/path/in/container/file.txt

# Example:
docker cp /home/user/html_file/index.html $container_name:/usr/share/nginx/html/index.html

# Directory (recursively)
docker cp /home/user/html_backup $container_name:/usr/share/nginx/html
docker exec $container_name ls -alsh /usr/share/nginx/html
```


## 🗃️ 2. Copying Multiple Files or Directories

```bash
# Copy multiple files (from host)
docker cp ./test.sh $container_name:/usr/share/nginx/html
docker cp ./Desktop $container_name:/usr/share/nginx/html
docker exec $container_name ls -alsh /usr/share/nginx/html
```

> ✅ Tip: Use `.` to copy all contents of a directory

```bash
docker cp ./Desktop/. $container_name:/usr/share/nginx/html
```



## 🧰 3. Backup and Restore Hidden Files (.dotfiles)

### 📤 Backup from Container

```bash
docker cp $container_name:/.dockerenv ./day08/.dockerenv
ls -alsh ./day08/.dockerenv
```

### 📥 Restore to Container

```bash
docker cp ./day08/.dockerenv $container_name:/.dockerenv_nedw
docker exec $container_name ls -alsh /
```

> ⚠️ Make sure to include the trailing `.` to copy *contents*, not the directory itself!



## 📦 4. Export Config Files from a Image

```bash
# Example: Exporting grafana.ini from Grafana container
docker run --rm -d --name temp-grafana grafana/grafana && docker cp temp-grafana:/etc/grafana/grafana.ini $PWD/day08/grafana.ini && docker stop temp-grafana
ls -alsh ./day08/
```


## ✅ 5. Safer Approach – Bind Mounts or Volumes (Recommended)

This is the safer and recommended way to interact with container files, using **bind mounts or Docker volumes**.

```bash
# Example of editing content via bind mount or volume
docker inspect $container_name | grep -A5 Mounts

# Modify file on HOST (affects container if using bind mount)
echo "Welcome to DevOps in Action" | sudo tee /home/user/html/index.html

# Access in browser
http://192.168.1.22:8085/
```


## ⚠️ 6. Advanced (Not Recommended) – Direct Access to Docker Filesystem

This method accesses container files directly via Docker’s internal storage (e.g., OverlayFS). Use **only for advanced troubleshooting or backup** purposes. It bypasses Docker’s APIs and may **corrupt data or containers** if misused.

```bash
# Create container
docker run -d --name test-nginx -p 8086:80 nginx

# Get container's merged directory path
CONT_PATH=$(docker inspect test-nginx --format='{{.GraphDriver.Data.MergedDir}}')

# 🔽 Copy file from container to host
sudo cp $CONT_PATH/usr/share/nginx/html/index.html $PWD/day08/index.html
cat $PWD/day08/index.html

# Access in browser
http://192.168.1.22:8086/

# 🔼 Copy file from host into container's filesystem (dangerous)
echo "Welcome to DevOps in Action" | sudo tee "$PWD/day08/index.html"
sudo cp $PWD/day08/index.html $CONT_PATH/usr/share/nginx/html/index.html 
sudo cat $CONT_PATH/usr/share/nginx/html/index.html 
```

> ⚠️ **Warning**: Direct manipulation of container storage may cause data corruption. Always prefer Docker CLI commands or volume mounts unless absolutely necessary.


## ✅ Summary Table

| **Task**                        | **Command Format**                             |
| ------------------------------- | ---------------------------------------------- |
| Copy file: Host → Container     | `docker cp file.txt container:/path/`          |
| Copy file: Container → Host     | `docker cp container:/file.txt /path/on/host/` |
| Copy entire directory           | `docker cp /src/. container:/dest/`            |
| Export file from temp container | `docker cp container:/path ./`                 |


## 📌 Final Tips

* Always verify file permissions after copying.
* Avoid copying into running containers' system paths (`/bin`, `/lib`) unless you know what you're doing.
* Use `docker volume` if frequent file sharing is needed.


## 🔗 Additional Resources

- 📘 [Docker cp command](https://docs.docker.com/reference/cli/docker/container/cp/)

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


