# 🐳 Docker Restart Policy – Master It Like a Pro! 🚀

Welcome to this video on **Docker Restart Policies**! Whether you're a Docker newbie or an intermediate user, this guide will help you **understand**, **practice**, and **master** restart policies to build resilient containers. Let’s dive in! 💡

## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/WEFlVX8T1Sk/maxresdefault.jpg)](https://youtu.be/WEFlVX8T1Sk)


## 📘 What is a Docker Restart Policy?

Docker restart policies help you **automatically restart containers** under certain conditions (like after failure, reboot, etc.) — useful for keeping your services up without manual intervention. Understanding Docker restart policies is crucial for maintaining container uptime and ensuring that services recover from failures automatically.

## 🔁 Available Restart Policies

| Policy         | Description                                                                 |
|-|--|
| `no`           | 🔇 *Default.* Never restart the container automatically.                     |
| `always`       | 🔁 Always restart the container if it stops.                                 |
| `unless-stopped` | ⚙️ Restart the container unless it's explicitly stopped by the user.        |
| `on-failure`   | ❌ Restart the container **only if it exits with a non-zero (failure) status code**. You can limit restart attempts. |

## 📌 Docker Restart Policies (Deep Dive)

| Restart Policy   | `docker stop` | `docker kill` | App crash (`exit`) | Host reboot | Daemon restart |
| ---------------- | ------------- | ------------- | ------------------ | ----------- | -------------- |
| `no`             | ❌             | ❌             | ❌                  | ❌           | ❌              |
| `always`         | ❌             | ❌             | ✅                  | ✅           | ✅              |
| `unless-stopped` | ❌             | ❌             | ✅                  | ✅*          | ✅*             |
| `on-failure`     | ❌             | ❌             | ✅**                | ❌           | ❌              |

Note: For unless-stopped: ✅* It **restarts only if it was running** before the **host reboot** or **daemon restart**.  
If you **stopped** the container manually (`docker stop`), it will **not** restart on reboot or daemon restart.
on-failure, ✅** indicates the container restarts only if the app exits with a non-zero exit code.

## 🔧 How to Set Restart Policy

You can set the restart policy using the `--restart` flag while running a container:

```bash
docker run --restart=<policy> [OPTIONS] IMAGE [COMMAND] [ARG...]
````

## 🎯 Practice Examples – Let’s Try Them Out!

### 1. 🚫 `no` – Default Behavior (No Restart)
This policy is the default setting. With the `no` restart policy, Docker does nothing if a container stops or crashes.

```bash
# Run container
docker run -itd --name no-restart ibraransaridocker/restart-policy-demo
# Above command is similar to below command
docker run -itd --name no-restart --restart=no ibraransaridocker/restart-policy-demo
```

### 2. 🔁 `always` – Restart Forever
When you set a container’s restart policy to `always`, Docker attempts to restart the container every time it stops, or If it is manually stopped, regardless of the reason. it is restarted only when Docker daemon restarts.

```bash
# 📌 Stop it and watch it restart:
docker run -itd --name always --restart=always ibraransaridocker/restart-policy-demo
docker stop always
docker ps -a | grep always
docker rm -f always

# 📌 Kill it and watch it restart:
docker run -itd --name always --restart=always ibraransaridocker/restart-policy-demo
docker kill always 
docker ps -a | grep always
docker rm -f always

# 📌 App crash (`exit`) and watch it restart:
docker run -itd --name always --restart=always ibraransaridocker/restart-policy-demo
docker exec always kill 1
docker inspect always --format='{{.RestartCount}}'
docker ps -a | grep always
docker rm -f always

# 📌 Daemon Restart
docker run -itd --name always --restart=always ibraransaridocker/restart-policy-demo
docker ps -a | grep always
sudo systemctl restart docker
docker ps -a | grep always
docker rm -f always

# 📌 Even after reboot:
docker run -itd --name always --restart=always ibraransaridocker/restart-policy-demo
docker ps -a | grep always
sudo init 6
docker ps -a | grep always
docker rm -f always
```

### 3. ⚙️ `unless-stopped` – Persistent Until You Stop It
The `unless-stopped` policy tells Docker to keep restarting the container until a developer forcibly stops it. It's similar to `always`, but it respects intentional stops.  it is not restarted even after Docker daemon restarts.

```bash
# Run Container
docker run -itd --name unless --restart=unless-stopped ibraransaridocker/restart-policy-demo

# ✔️ This will restart unless you explicitly stop it with:
docker stop test-unless
```
Then restart your system — it won’t restart again unless you start it manually.

### 4. ❌ `on-failure` – Conditional Restart Based on Exit Code
The `on-failure` policy instructs Docker to restart the container only if it exits with an error code (non-zero exit status). Restart the container if it exits due to an error.

```bash
# Run container
docker run -itd --name failure --restart=always ibraransaridocker/restart-policy-demo

# 📌 App crash (`exit`) and watch it restart:
docker exec failure kill 1
docker ps -a | grep failure

# 📌 It will try to restart 3 times, then stop.
Check restart count:
docker inspect test-failure --format='{{.RestartCount}}'
```

##  📝 Container’s Restart Policy in Production(Check and update Policy)

```bash
# You can inspect any container’s restart policy with:
docker inspect <container_name> --format='{{.HostConfig.RestartPolicy.Name}}'

# Check all containers restart policy
docker inspect --format '{{.Name}} Restart: {{ .HostConfig.RestartPolicy.Name }}' $(docker ps -aq)

# Reset restart  single container
docker update --restart=no <container_name_or_id>

# Reset restart  All container
docker update --restart=no $(docker ps -q)

# Set all restart always
docker update --restart=always $(docker ps -aq)

```

## 🧼 Clean Up (After Practice)

```bash
docker rm -f $(docker ps -aq)
```

## Choosing the Right Restart Policy

Here are some considerations for choosing the right restart policy:

- Development vs. Production: In a development environment, you might prefer `no` to debug issues, while in production, `always` or `on-failure` could be more appropriate.
- Stateless vs. Stateful Containers: Stateless containers can often use `always`, but stateful containers might need a more nuanced approach like `on-failure`.
- Dependent Services: For containers that depend on other services, `on-failure` ensures they don't restart in a loop if a dependency is unavailable.
## ✅ Best Practices

* Use `always` for **critical services** that should never go down.
* Use `unless-stopped` for services you want to **auto-restart**, but still be able to manually shut down.
* Use `on-failure` for **short-lived jobs** or **scripts** that may fail and need retry.
* Avoid `no` unless you're doing one-off or testing containers.

## 🔗 Additional Resources

- 📘 [Docker Policy](https://docs.docker.com/config/containers/start-containers-automatically/)
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