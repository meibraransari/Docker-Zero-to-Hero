# 🚀 Deep Dive into Docker Containers Logging: From Basic to Advanced 🐳

This guide explores Docker container logging in depth, covering everything from basic concepts to advanced production-grade strategies. Perfect for creating a comprehensive YouTube video on Docker logs! 🎥

## 📚 Introduction to Docker Logging

Docker containers generate logs to track their activities, errors, and runtime behavior. These logs are essential for debugging, monitoring, and ensuring the health of applications in development and production environments. Docker provides a flexible logging system that can be tailored to various use cases. Let's dive into the fundamentals and scale up to advanced techniques! 🔍

## 🤔 Why Logging Matters? 

- **Debugging**: Identify and fix issues in containerized applications.
- **Monitoring**: Track performance and system health.
- **Auditing**: Maintain records for compliance and security.
- **Troubleshooting**: Pinpoint failures in production systems.

## 🛠️ Basics of Docker Container Logs

Docker captures logs from a container’s `stdout` (standard output) and `stderr` (standard error) streams. By default, Docker uses the `json-file` logging driver to store logs.
## `stdout` vs `stderr`

| Stream   | Purpose                           |
| -------- | --------------------------------- |
| `stdout` | Standard output (normal messages) |
| `stderr` | Standard error (error messages)   |
* **`stdout`** is for successful output.
* **`stderr`** is for errors and warnings.
> [!attention] 
> In Docker logs both `stdout` vs `stderr` is combined, to see separately see below examples 

## 🔍 Docker help command

Get options using help command.

```bash
docker container logs --help
Usage:  docker container logs [OPTIONS] CONTAINER
Fetch the logs of a container
Aliases:
  docker container logs, docker logs
Options:
      --details        Show extra details provided to logs
  -f, --follow         Follow log output
      --since string   Show logs since timestamp (e.g. "2013-01-02T13:23:37Z") or relative
                       (e.g. "42m" for 42 minutes)
  -n, --tail string    Number of lines to show from the end of the logs (default "all")
  -t, --timestamps     Show timestamps
      --until string   Show logs before a timestamp (e.g. "2013-01-02T13:23:37Z") or relative
                       (e.g. "42m" for 42 minutes)
```
## ✅ Syntax Examples
```bash
docker logs --follow <container_name_or_id>
docker logs --details <container_name_or_id>
docker logs --timestamps <container_name_or_id>
docker logs --tail <number> <container_name_or_id>
docker logs --tail 5 <container_name_or_id>
docker logs --tail 5 --follow <container_name_or_id>
docker logs <container_id> --since YYYY-MM-DD
docker logs <container_id> --until YYYY-MM-DD
docker logs --since <YYYY-MM-DDTHH:MM:SS> --until <YYYY-MM-DDTHH:MM:SS> <container_name_or_id>
docker logs <container_id> | grep pattern
docker logs <container_id> | grep -i error
```
## 🧪 LAB Activity

```bash
# Create containers to monitor log
docker run --name log -d busybox sh -c "while true; do echo \$(date) '==> Welcome to DevOps in Action!'; sleep 1; done"
docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker run -d  --name=logger chentex/random-logger:latest 100 400

# Set container name
container_name_or_id=logger

# Check logs with all poissble way
docker ps --size
docker logs --follow $container_name_or_id
docker logs --details $container_name_or_id
docker logs --timestamps $container_name_or_id
docker logs --tail 10 $container_name_or_id
docker logs --tail 5 --follow $container_name_or_id
docker logs $container_name_or_id --since 2025-06-10
docker logs $container_name_or_id --until 2025-06-11
docker logs --since 2025-06-10 --until 2025-06-11 $container_name_or_id
docker logs $container_name_or_id | grep -i error
docker logs $container_name_or_id | grep -i failed
docker logs $container_name_or_id | grep -i -E 'error|warning|stop|fail'
docker logs --since 2025-06-10 $container_name_or_id | grep "error"

# Stdout and Stderr log export
docker run --name log-test --rm -d busybox sh -c "echo 'This is stdout'; echo 'This is stderr' >&2; sleep 100"
docker logs log-test > /tmp/stdout.log 2>/tmp/stderr.log
cat /tmp/stdout.log
cat /tmp/stderr.log

# Check log path
docker inspect --format='{{.LogPath}}' $container_name_or_id

# View logs for a container
sudo cat /var/lib/docker/containers/<CONTAINER ID>/<CONTAINER ID>-json.log

# Tail logs for a container 
sudo tail -f /var/lib/docker/containers/<CONTAINER ID>/<CONTAINER ID>-json.log

# Check size of log file of selected containers
sudo du -sh $(docker inspect --format='{{.LogPath}}' $container_name_or_id)

# Check log size of all containers at once
sudo find /var/lib/docker/containers -type f -name "*.log" -print0 | sudo du -shc --files0-from - | tail -n1

# Check log size of all containers at seprately
docker ps -aq | while read cid; do 
  name=$(docker inspect --format='{{.Name}}' "$cid" | sed 's/^\/\?//')
  log_path=$(docker inspect --format='{{.LogPath}}' "$cid")
  size=$(sudo du -sh "$log_path" 2>/dev/null | cut -f1)
  echo -e "$name\t$size"
done

# Export/Backup logs way
docker logs --since=1h $container_name_or_id > /tmp/save.txt
docker logs --since="2024-12-01T00:00:00" --until="2024-12-10T23:59:59" my-container > /tmp/exported.log
sudo cp -a $(docker inspect --format='{{.LogPath}}' $container_name_or_id) /tmp/api.log

# To delete the single container logs:
# Clear log file
sudo truncate -s 0 $(docker inspect --format='{{.LogPath}}' $container_name_or_id)
#sudo echo "" > $(sudo docker inspect --format='{{.LogPath}}' $container_name_or_id)
#: > $(sudo docker inspect --format='{{.LogPath}}' $container_name_or_id)

# Delete the log files of all docker containers in your system.
sudo find /var/lib/docker/containers -type f -name "*json.log" -exec truncate -s 0 {} \;
#sudo find /var/lib/docker/containers/ -name '*-json.log' -exec truncate -s 0 {} \;
#find /var/lib/docker/containers/ -type f -name "*.log" -delete
#sudo truncate -s 0 /var/lib/docker/containers/*/*-json.log 
```
## 🐳 Docker Logging Lab: Inspecting Container Logs with container name, image name and id in logs 📝

Explore how to configure Docker logging options and inspect container logs directly from the file system with tag in log. This hands-on lab demonstrates tagging logs with metadata and analyzing structured JSON log output.

```bash
# Set container Name in logs
docker run -itd --name=nginx -p 8090:80 --log-opt tag="{{.Name}}"  nginx
curl http://localhost:8090
docker logs nginx
CONTAINER_ID=$(docker inspect -f '{{.Id}}' nginx)
sudo cat /var/lib/docker/containers/$CONTAINER_ID/$CONTAINER_ID-json.log | jq

# Set container ImageName, Name and ID in logs
docker rm -f nginx
docker run -itd --name=nginx -p 8081:80 --log-opt tag="{{.ImageName}}/{{.Name}}/{{.ID}}"  nginx
curl http://localhost:8081
docker logs nginx
CONTAINER_ID=$(docker inspect -f '{{.Id}}' nginx)
sudo cat /var/lib/docker/containers/$CONTAINER_ID/$CONTAINER_ID-json.log | jq

# Alternative use below command
sudo cat /var/lib/docker/containers/$(docker inspect --format='{{.Id}}' nginx)/$(docker inspect --format='{{.Id}}' nginx)-json.log | jq
sudo jq . /var/lib/docker/containers/$(docker inspect -f '{{.Id}}' nginx)/$(docker inspect -f '{{.Id}}' nginx)-json.log
```
## 📝Default Logging Driver: `json-file` 

The `json-file` driver stores logs as JSON objects on the host filesystem, typically in `/var/lib/docker/containers/<container_id>/<container_id>-json.log`.
**Pros**:
- Simple to use.
- Logs are persistent on the host.
- Supports `docker logs` command.
**Cons**:
- Logs can consume significant disk space.
- Not ideal for large-scale production.
## ⚙️ Setting/Changing Logging Drivers Globally 🌍

```bash 
# Check global logging driver
docker info --format '{{json .}}' | jq
docker info --format '{{.LoggingDriver}}' 

# Supported plugins
docker info --format '{{json .Plugins.Log}}'
docker info --format '{{json .Plugins}}' | jq '{Log: .Log}'
```

Edit `/etc/docker/daemon.json` to set a default logging driver for all containers:
```json
sudo nano /etc/docker/daemon.json

# -----------------------
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
# -----------------------
## Run syslog server
docker run -d --name syslog-server \
  -p 514:514/tcp -p 514:514/udp \
  rsyslog/syslog_appliance_alpine
#### check logs
docker exec -it syslog-server cat /var/log/syslog
# -----------------------
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "udp://localhost:514"
  }
}
# -----------------------
{
  "log-driver": "syslog",
  "log-opts": {
    "mode": "non-blocking"
  }
}
# -----------------------
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "25m",
    "max-file": "10",
    "labels": "production_bind",
    "env": "os,customer"
  }
}
dockerd --validate --config-file=/etc/docker/daemon.json
sudo systemctl restart docker
sudo systemctl status docker
```

- `max-size`: Limits the size of each log file.
- `max-file`: Specifies the number of rotated log files.

> [!info] 
> Ref:  [Daemon configuration file](https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file)
##  🚦 Set directly log drivers to specific containers to override global config
```bash
# Run nginx override global config 
docker run -d \
--name nginx \
--log-driver json-file \
--log-opt max-size=100m \
--log-opt max-file=3 \
nginx

# Check Container logging driver
docker inspect -f '{{.HostConfig.LogConfig.Type}}' nginx
```

✅ This keeps logs limited to 100MB in total (3 files × 100MB each).

## 🐳 Docker Logging Drivers Overview: Customizing Logging Drivers

Docker supports multiple **logging drivers** to handle container logs differently based on your needs. These drivers redirect logs to various destinations such as syslog, AWS CloudWatch, or Fluentd.
## 🔌 Supported Logging Drivers

| Driver     | Description                                                                                  |
|------------|----------------------------------------------------------------------------------------------|
| 🚫 **none**      | No logs are available for the container and `docker logs` returns no output.                |
| 📦 **local**     | Logs are stored in a custom format designed for minimal overhead.                           |
| 🗃️ **json-file** | Logs are formatted as JSON. This is the **default** logging driver for Docker.             |
| 🖧 **syslog**    | Writes log messages to the syslog facility. Requires syslog daemon running on host.        |
| 📝 **journald**  | Writes log messages to journald. Requires journald daemon running on host.                  |
| 🐊 **gelf**      | Sends logs to a Graylog Extended Log Format (GELF) endpoint like Graylog or Logstash.      |
| 🐳 **fluentd**   | Sends logs to Fluentd (forward input). Requires Fluentd daemon running on host.             |
| ☁️ **awslogs**   | Sends logs to Amazon CloudWatch Logs.                                                     |
| 🔍 **splunk**    | Sends logs to Splunk using the HTTP Event Collector.                                      |
| 🪟 **etwlogs**   | Sends logs as Event Tracing for Windows (ETW) events. Available only on Windows platforms. |
| 🌐 **gcplogs**   | Sends logs to Google Cloud Platform (GCP) Logging.                                        |

> For each driver, you can find configurable options in the [official Docker logging documentation](https://docs.docker.com/config/containers/logging/configure/).

### ⚠️ Limitations of Logging Drivers

- Reading log information may require **decompressing rotated log files**, causing:
  - Temporary increase in disk usage (until logs are read)
  - Increased CPU usage while decompressing
- The **maximum size** of log files depends on the capacity of the host storage where the Docker data directory resides.

## 🛠 Set driver at runtime:
1. **`none`**: Disables logging entirely (useful for minimal setups).
    docker run --log-driver=none --name my-app nginx 
2. **`local`**: Stores logs in a custom binary format, optimized for performance.
    docker run --log-driver=local --log-opt max-size=10m --name my-app nginx
3. **`syslog`**: Sends logs to a syslog server (useful for centralized logging).
    docker run --log-driver=syslog --log-opt syslog-address=udp://localhost:514 --name my-app nginx
4. **`journald`**: Integrates with `systemd` journal for Linux systems.
    docker run --log-driver=journald --name my-app nginx

## 📊 GUI Logging APP 1
```bash
docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 8080:8080 amir20/dozzle:latest
# Dozzle will be available at http://localhost:8080/.
# https://github.com/amir20/dozzle
```

## 📊 GUI Logging APP 2
```
docker run --restart=always --name c-docker-web-ui -d -p 9000:9000  -v /var/run/docker.sock:/var/run/docker.sock pottava/docker-webui
# Dozzle will be available at http://localhost:9000/.
# https://github.com/pottava/docker-webui
```

## 📊 GUI Logging APP 3
```
docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  portainer/portainer-ce:latest
```
## 👀 How to Properly Log (Best Practices)
- Log to the Standard Output Stream
- Limit the log size
- Rotate Logs

## 🎯 Summary

| Concept             | Dev Environment | Production Guidance           |
| ------------------- | --------------- | ----------------------------- |
| Default Driver      | `json-file`     | Use `fluentd`, `gelf`, etc.   |
| Log Rotation        | Optional        | Mandatory                     |
| Centralized Logging | Optional        | Highly Recommended            |
| Log Structure       | Text logs       | Structured JSON logs          |
| Log Forwarding      | Not needed      | Critical for monitoring/alert |


---
## 🐳 Docker Logging Resources

- 🏷️ [Log Tags Overview](https://docs.docker.com/engine/logging/log_tags/)  
  Learn about available log tags and how to use them with logging drivers.
- ⚙️ [Daemon Configuration File](https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file)  
  Configure the Docker daemon using a JSON file, including logging settings.
- 📄 [Container Logs Command](https://docs.docker.com/reference/cli/docker/container/logs/)  
  Usage guide for the `docker container logs` CLI command.
- 🛠️ [Configure Logging Drivers](https://docs.docker.com/engine/logging/configure/)  
  Instructions on how to configure different logging drivers in Docker.
- 🔖 [Log Tags in Container Logging](https://docs.docker.com/config/containers/logging/log_tags/)  
  Additional info on log tags for container logging configuration.


## 🛠️ DevOps Integration
[Click here...!](./assets/DevOps.md)


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