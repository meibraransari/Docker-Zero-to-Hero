---
Created: 2025-05-29T07:52:46+05:30
Updated: 2025-05-29T07:55:56+05:30
Maintainer: Ibrar Ansari
---

# 🐳 **Day 4: Mastering docker ps Command - With examlpes!**

This guide provides a deep dive of the `docker ps` command, including how to list, filter, format, and count containers and images.
Docker ps command lists containers on your system. It displays useful information such as container IDs, image names, uptime, exposed ports and many more.. It's an essential tool to working with the containers. 🐳📋

<!--
## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/TXIQYO21ais/maxresdefault.jpg)](https://youtu.be/TXIQYO21ais)

-->

---

## 📋 Basic Usage


### ❔ Get Help using help command
```
docker ps --help
```
```
Usage:  docker ps [OPTIONS]

List containers

Aliases:
  docker container ls, docker container list, docker container ps, docker ps

Options:
  -a, --all             Show all containers (default shows just running)
  -f, --filter filter   Filter output based on conditions provided
      --format string   Format output using a custom template:
                        'table':            Print output in table format with column headers (default)
                        'table TEMPLATE':   Print output in table format using the given Go template
                        'json':             Print in JSON format
                        'TEMPLATE':         Print output using the given Go template.
                        Refer to https://docs.docker.com/go/formatting/ for more information about formatting output with templates
  -n, --last int        Show n last created containers (includes all states) (default -1)
  -l, --latest          Show the latest created container (includes all states)
      --no-trunc        Don't truncate output
  -q, --quiet           Only display container IDs
  -s, --size            Display total file sizes

```


### 1. Show Running Containers

```
docker ps
```

### 2. Show All Containers (Running + Stopped)

```
docker ps -a
```

### 3. Show Disk Usage per Container

```
docker ps -s
docker ps -as

```

### 4. Show Last N Created Containers

```
docker ps --last 4
# or
docker ps -n 4
```

### 5. Show the Most Recently Created Container

```
docker ps -l
# or
docker ps --latest
```

### 6. Show Only container IDs

```
docker ps -q
docker ps -aq
# or
docker ps --quiet
docker ps -a --quiet
```

---

## 🔍 Filtering Containers

### Filter by Name

```
docker ps -f "name=test-container"
or
docker ps --filter "name=test-container"
```

### Filter by Container ID

```
docker ps -a -f "id=aca09d8707d8"
or
docker ps -a --filter "id=aca09d8707d8"
```

### Filter by Status

```
docker ps --filter status=running
docker ps --filter status=exited
```

### Filter by Ancestor (Image)

```
docker ps --filter ancestor=nginx
```

### Filter by Creation Time before/after container

```
docker ps -f before=whoami
docker ps -f since=nd
```
### Sort containers by creation time (most recent first)

```
docker ps -a --format '{{.CreatedAt}}\t{{.Names}}' | sort -r
```
### Filter by Network, Volume, Port, Label, Health

```
docker ps --filter publish=8080
docker ps --filter "label=com.example.app=web"
docker ps --filter health=healthy
docker ps --filter network=bridge
docker ps --filter volume=myvol
docker ps -a --filter exited=0
```

### Multiple Filters

```
docker ps --filter status=running --filter ancestor=nginx
```

## 🔢 Counting Containers

### Count Running Containers

```
docker ps -q | wc -l
```

### Get Count via Docker Info

```
docker info --format '{{json .ContainersRunning}}'
```

### Count All Containers (Running + Stopped)

```
docker ps -a -q | wc -l
```

### Count Matching Containers by Image Name

```
docker ps | grep ibraransaridocker/coming-soon | wc -l
```

## 🛠️ Custom Formatting

### Simple Name Format

```
docker ps --format '{{.Names}}'
or
docker ps -a --format "{{.Names}}"
or
docker ps -a --format "table {{.Names}}"
```

### Detailed Format with Variables

```
FORMAT="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"
docker ps -a --format="$FORMAT"
```

### Tabular Format Output

```
docker ps -a --format "table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}\t{{.Command}}\t{{.RunningFor}}"
```
---

## 🔍 Inspect Available Format Fields

### View Raw Output in JSON

```
docker ps --format '{{json .}}' | jq
```

### List All Available Format Keys

```
docker ps --format '{{json .}}' | jq -r 'keys_unsorted[]' | sort -u
```

### List All Format Keys from All Containers

```
# Create sample container to provide all keys
docker run -itd \
  --name test-container \
  --hostname custom-hostname \
  --env MY_ENV=example \
  --label app=demo \
  --label com.example.app=web \
  --mount type=bind,source=/tmp,target=/app/tmp,readonly \
  --mount type=volume,source=myvol,target=/app/data \
  --network bridge \
  --publish 8080:80 \
  --restart unless-stopped \
  --memory 512m \
  --cpu-shares 512 \
  --health-cmd="curl -f http://localhost || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  --health-start-period=5s \
  nginx:latest

# Run to get key
docker inspect $(docker ps -q) | jq '.[0] | keys_unsorted' | sort -u
# or
docker inspect $(docker ps -q) | jq -r '.[0] | keys_unsorted[]' | sort -u

```

<!--
This line will be hidden and not rendered.
So you can hide notes or stuff here.
### Alternative using grep and sed (less accurate)

```
docker ps --format '{{json .}}' | jq -s 'map(keys) | add | unique | sort'
or
docker ps --format '{{json .}}' | grep -o '"[^"]*":' | sed 's/"//g' | sed 's/://g' | sort -u
```

<details>
  <summary>Click to expand</summary>

  Here is some hidden content.
  You can put multiple lines here.

</details>



docker inspect $(docker ps -q) | jq -r '.[0].State | keys_unsorted[]'

docker inspect $(docker ps -q) | jq -r '.[0].State.Health.Status'

docker inspect $(docker ps -q) | jq -r '.[0].State.Health'


-->



---

## 🧩 All Available `--format` Fields

Here are all the fields you can use with `--format`:

| Field         | Description                               |
| ------------- | ----------------------------------------- |
| `.ID`         | Container ID                              |
| `.Names`      | Container name(s)                         |
| `.Image`      | Image name                                |
| `.ImageID`    | Image ID                                  |
| `.Command`    | Startup command                           |
| `.CreatedAt`  | Creation time                             |
| `.RunningFor` | Time running                              |
| `.Ports`      | Port mappings                             |
| `.Status`     | Status string                             |
| `.Size`       | Disk usage size (needs `-s`)              |
| `.Labels`     | All labels                                |
| `.Label`      | Specific label (e.g., `{{.Label "key"}}`) |
| `.Mounts`     | Mount points                              |
| `.Networks`   | Networks attached                         |
| `.State`      | Running, exited, paused, etc.             |
| `.Health`     | Healthcheck status                        |

---
## 📚 More Info

For full details, check the [official Docker formatting docs](https://docs.docker.com/engine/cli/formatting/) 📘

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

## Hit the Star! ⭐
***If you are planning to use this repo for learning, please hit the star. Thanks!***
****