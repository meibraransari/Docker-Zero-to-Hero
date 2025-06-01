---
Created: 2025-06-01T07:21:01+05:30
Updated: 2025-06-01T07:58:50+05:30
Maintainer: Ibrar Ansari
---

# 🚢 Day 07 - Docker Inspect Command Deep Dive

Explore the powerful `docker inspect` command to fetch deep-level metadata of Docker containers, including their environment, volumes, networks, logs, and more.

Here is the `docker inspect --help` information formatted as a Markdown section:



## 🛠️ `docker inspect` Help

```bash
docker inspect --help
```

### 📄 Usage

```text
Usage:  docker inspect [OPTIONS] NAME|ID [NAME|ID...]
```

Return low-level information on Docker objects.

### ⚙️ Options

| Option          | Description                                                                                                                                                                                 |
|  | - |
| `-f, --format`  | Format output using a custom template:<br> - `'json'`: Print in JSON format<br> - `'TEMPLATE'`: Use a Go template for output. See [formatting docs](https://docs.docker.com/go/formatting/) |
| `-s, --size`    | Display total file sizes (only for containers)                                                                                                                                              |
| `--type string` | Return JSON for the specified type                                                                                                                                                          |




## 🔧 Set Example Container Name

```bash
# Example container ID or name
container_name="test-container"
```



## 🕵️‍♂️ Basic Inspection

```bash
# Inspect full details of a container
docker inspect $container_name
```

## ⚙️ Full Config (JSON)

```bash
# Get the full container config in JSON format
docker inspect --format='{{json .Config}}' $container_name | jq
```

## 🖼️ Image Name

```bash
# Get the image name used to create the container
docker inspect --format='{{.Config.Image}}' $container_name
```


## 🌍 Network Information

```bash
# Get container network info
docker inspect --format='{{json .NetworkSettings.Networks}}' $container_name | jq

# Get container IP address of known network.
docker inspect --format='{{.NetworkSettings.Networks.bridge.IPAddress}}' $container_name

# Get container IP address of all network
# It's useful when a container is connected to multiple networks and you want to get values like IPAddress from each.
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_name

# Get the MAC address of the container
docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $container_name

# Get port mapping 🔌 
docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}}{{end}}' $container_name

# Get the host-port to container-port mappings 🔌 
docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $container_name
```

```bash
# Get container IPs for all running containers
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)

# With container names
docker ps -q | xargs -I {} docker inspect --format '{{.Name}}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {} | sed 's|/||'
```



## ⚙️ Restart Policy

```bash
# Show restart policy of all containers
docker ps -aq | xargs docker inspect --format '{{.Name}} Restart: {{.HostConfig.RestartPolicy.Name}}'

# Alternative using subshell
docker inspect --format '{{.Name}} Restart: {{.HostConfig.RestartPolicy.Name}}' $(docker ps -aq)
```



## 🌱 Environment Variables

```bash
# List all environment variables
docker inspect --format='{{range $index, $value := .Config.Env}}{{$value}}{{"\n"}}{{end}}' $container_name
```



## 🗃️ Mounts & Volumes

```bash
# Show all mount sources
docker inspect --format='{{range .Mounts}}{{.Source}}{{"\n"}}{{end}}' $container_name

# Show source and destination
docker inspect --format='{{range .Mounts}}{{.Source}}:{{.Destination}}{{"\n"}}{{end}}' $container_name

# Using jq to filter only bind/volume mounts
docker inspect $container_name | jq '.[0].Mounts[] | select(.Type == "bind" or .Type == "volume") | {Type, Source, Destination}'

# Using grep (less structured)
docker inspect $container_name | grep -i -A 17 "Mounts"
```



## 🪵 Log Paths & Sizes

```bash
# Get container log file path
docker inspect --format='{{.LogPath}}' $container_name

# View log size
sudo du -sh $(docker inspect --format='{{.LogPath}}' $container_name)

# Clear container logs
echo "" > $(docker inspect --format='{{.LogPath}}' $container_name)

# Copy log file to another location
sudo cp -a $(docker inspect --format='{{.LogPath}}' $container_name) /tmp/api.log

# Get log sizes for all containers
docker ps -aq | while read cid; do 
  name=$(docker inspect --format='{{.Name}}' "$cid" | sed 's/^\/\?//')
  log_path=$(docker inspect --format='{{.LogPath}}' "$cid")
  size=$(sudo du -sh "$log_path" 2>/dev/null | cut -f1)
  echo -e "$name\t$size"
done
```



## 📊 Resource Allocation

```bash
# Show allocated CPU shares
docker inspect --format='{{.HostConfig.CPUShares}}' $container_name

# Show memory limit (in bytes)
docker inspect --format='{{.HostConfig.Memory}}' $container_name
```



## 🧪 Health Check

```bash
# Show container health status (basic)
docker inspect --format='{{.State.Health.Status}}' $container_name

# Alternative using jq
docker inspect $container_name | jq -r ".[].State.Health.Status"
```



## 🏷️ Labels & Metadata

```bash
# Get all container labels as JSON
docker inspect $container_name --format '{{json .Config.Labels}}'
```



## 🧾 Container Exit Code & Logging Config

```bash
# Check exit code
docker inspect $container_name | grep ExitCode

# Log config
docker inspect $container_name | grep LogConfig

# Log max size (if configured)
docker inspect $container_name | grep -i MaxSize
```



## 🏃 Find Executed Commands

```bash
# Path and arguments used to start container
docker inspect -f "{{.Name}} {{.Path}} {{.Args}}" $(docker ps -a -q)

# Show .Config.Cmd value
docker inspect -f "{{.Name}} {{.Config.Cmd}}" $(docker ps -a -q)

# With container ID
docker inspect -f "{{.Path}} {{.Args}} ({{.Id}})" $(docker ps -a -q)
```

## 🐳  `docker inspect` template to regenerate the `docker run` command from created container

```bash
# This file defines how the output from docker inspect should be presented — potentially in a cleaner, structured format.
docker inspect \
  --format "$(curl -s https://raw.githubusercontent.com/meibraransari/Docker-Zero-to-Hero/refs/heads/main/Day-07_Docker_insect_command/assets/run.tpl)" \
  $container_name
```

## 🔗 Additional Resources

- 🧰 [Docker inspect](https://docs.docker.com/reference/cli/docker/container/inspect/)
- 📘 [Format command and log output](https://docs.docker.com/engine/cli/formatting/)
- 📘 [JSON Path Finder](https://jsonpathfinder.com/)


## ✅ Final Tips

* Use `jq` for cleaner, structured JSON parsing.
* Combine `docker inspect` with `awk`, `xargs`, `grep`, or `sed` to build powerful inspection scripts.
* Combine with monitoring and alerting for proactive container management.


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


