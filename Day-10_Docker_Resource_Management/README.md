# 🐳 Docker Resource Management Guide

Managing system resources like CPU, memory, disk, and I/O is crucial in production environments to ensure containers behave predictably and don't starve the host or other containers.

## 📌 Why Resource Management Matters?

- Prevent 🛑 one container from eating up all system resources.
- Ensure fair use and better system **stability** and **performance**.
- Protect the host and other containers from **resource exhaustion**.
- Simulate production-like limits in development.
- Efficient Use of Infrastructure


## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/wQNdXVUP9BA/maxresdefault.jpg)](https://youtu.be/wQNdXVUP9BA)


# Docker Resource Limits: Key Components

Docker resource limits allow developers to control how much CPU, memory, and other system resources a container can use. Below are the primary components for configuring these limits.
## 1. Memory Limits

- **`--memory` (`-m`)**  
  Sets a **hard limit** on memory. The container cannot exceed this amount.  
  **Example:** `-m 512m` (limits memory usage to 512 MB)

- **`--memory-reservation`**  
  Sets a **soft limit** (baseline memory usage). The container can exceed it if the host has spare memory, but will be throttled during high usage.

- **`--memory-swap`**  
  Controls the total memory (RAM + swap).  
  - Set it **equal to** `--memory` to **disable swap**.  
  - Set it **greater than** `--memory` to **allow swapping**.  
## 2. CPU Limits

- **`--cpus`**  
  Limits the container to a specific number of CPUs or fractions.  
  **Example:** `--cpus=1.5` (limits to 1.5 CPU cores)

- **`--cpu-shares`**  
  Sets a **relative CPU weight**.  
  - Default: `1024`  
  - Higher values mean higher CPU priority during contention.  
  **Example:** `--cpu-shares=2048`

- **`--cpu-quota`** and **`--cpu-period`**  
  Enforce **CPU throttling** based on time quotas.  
  **Example:**  
\--cpu-period=100000
\--cpu-quota=50000

> Limits the container to **50% of a CPU every 100 ms**.
## 3. I/O Limits

- **`--device-read-bps` / `--device-write-bps`**  
Throttle read/write speeds to devices (in bytes per second).  
**Example:** `--device-read-bps=/dev/sda:10mb`

- **`--device-read-iops` / `--device-write-iops`**  
Limits the number of **I/O operations per second (IOPS)**. Helps manage disk bandwidth in I/O-constrained environments.

> [!attention] 
> Be mindful when configuring swap on your Docker hosts. Swap is slower than memory but can provide a buffer against running out of system memory 

---
# 🚀 Deploy Portainer to View Docker Resource Limits via GUI

Easily monitor and manage Docker resources with **Portainer**'s user-friendly interface.

```bash
docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  portainer/portainer-ce:latest
```

🔹 **Port**: Access the GUI at `http://localhost:9000`
🔹 **Volume**: Mounts Docker socket for management access
🔹 **Restart Policy**: Ensures Portainer starts on system reboot

🧭 Once running, open your browser and head to `http://localhost:9000` in my case it is `http://192.168.192.221:9000` to complete setup and start managing containers with resource insights!

---
## 🧠 Memory Limits 

### ➕ Set Memory Limit (Test Cases)

```bash
# Get help
docker run --help | grep memory

# Run container with memory
docker run -itd --name=mem -m 512m ibraransaridocker/network-debug-tools:latest
# 📌 This restricts the container to **512MB of RAM**. If the container tries to use more, it will be **killed** (OOM - Out of Memory).

# Check assigned memory
docker inspect --format='{{.HostConfig.Memory}}' mem | awk '{print $1/1024/1024 " MB"}'

# See assigned memory
docker stats mem

# 🧪 Stress test inside your container
docker exec -it mem /bin/bash
apt update && apt install -y stress
stress --vm 2 --vm-bytes 900M --timeout 30s

# Watch live OOM
sudo dmesg -w | grep -i 'killed process'

# Check results
sudo dmesg | grep -i 'killed process'
sudo journalctl -k | grep -i 'killed process'
````

### ➕ Memory + Swap (Test Cases)

```bash
# Get help
docker run --help | grep swap

# Syntax
docker run -dit --memory="[ram]" --memory-swap="[ram+swap]" [image]

# For example, to run a container with a 512 MB RAM limit and 1GB of swap memory, type:
docker run -itd --name=swap -m 512m --memory-swap=1g ibraransaridocker/network-debug-tools:latest

# Check assigned memory
docker inspect --format='{{.HostConfig.Memory}}' swap | awk '{print $1/1024/1024 " MB"}'
docker inspect --format='{{.HostConfig.MemorySwap}}' swap | awk '{print $1/1024/1024 " MB"}'

# Connect container and install stress tool
docker exec -it swap bash
apt update && apt install -y stress stress-ng 

# 🧪 Test Case 1: Soft Memory Load (within 512MB)
# 🔹 Goal: Should NOT crash
stress-ng --vm 1 --vm-bytes 400M --vm-keep -t 20s

# 🧪 Test Case 2: Exceed RAM, Stay Under Swap Limit (700MB)
# 🔹 Goal: Use swap, no crash
stress-ng --vm 1 --vm-bytes 700M --vm-keep --vm-method all -t 30s

# 🧪 Test Case 3: Exceed Total Limit (>1GB) → Trigger OOM
# 🔹 Goal: Container crashes due to memory overuse
stress-ng --vm 1 --vm-bytes 2G --vm-keep --vm-method all -t 60s

# Watch live
docker stats swap

# Watch live OOM
sudo dmesg -w | grep -i 'killed process'
# Check results
sudo dmesg | grep -i 'killed process'
sudo journalctl -k | grep -i 'killed process'
```

---
## 🧮 CPU Limits

### 🎚️ Set CPU Quota (Absolute )Limit

```bash
# Get help
docker run --help | grep cpu

# Check available cpu on host
docker run --rm busybox nproc

# Run container with 512 CPU
docker run -itd --name=cpu --cpus=1.5 ibraransaridocker/network-debug-tools:latest
Example: `--cpus=1.5` lets container use 1.5 CPUs.

# Inspect CPU
docker inspect --format='{{.HostConfig.NanoCpus}}' cpu | awk '{printf "%.1f\n", $1 / 1000000000}'

# Stress test
docker exec -it cpu apt update
docker exec -it cpu apt install -y stress
docker exec -it cpu stress --cpu 2 --timeout 30s
- This uses 2 CPU workers (threads) but the container is still limited to 1.5 CPUs.   
- This lets you observe throttling or how Docker enforces CPU limits.

#🧮 How CPU % works in `docker stats`
- The **CPU %** shown is **per host logical CPU core**.
- If you see `150%`, it means the container is using **1.5 full logical CPUs worth of processing power**.  
- If you had 4 logical cores and ran a container with `--cpus=2`, the container could hit `200%`.

# Stats
docker stats cpu
```

---
## 🔢 Limit Number of Processes (PIDs)  📦

```bash
# 🔐 Restrict container to max **5 processes**. Prevents fork bombs 🧨.
docker run -itd --name=pid --pids-limit=5 ubuntu

# Test pid
sleep 500 & sleep 500 & sleep 500 & sleep 500 & sleep 500
or 
for i in {1..10}; do sleep 500 & done

# Check pid
docker stats pid
```

---
## 🎮 GPU Access (NVIDIA)

```
# Run an Ubuntu container with access to all GPUs, then execute 'nvidia-smi' to check NVIDIA GPU status
docker run -it --rm --gpus all ubuntu nvidia-smi

# Use the device option to specify GPUs. For example:
docker run -it --rm --gpus device=GPU-3a23c669-1f69-c64e-cf85-44e9b07e7a2a ubuntu nvidia-smi

# Exposes that specific GPU.
docker run -it --rm --gpus '"device=0,2"' ubuntu nvidia-smi

# Set NVIDIA capabilities
docker run --gpus 'all,capabilities=utility' --rm ubuntu nvidia-smi
```
## 💽 Block I/O Limits (Disk)

```bash
💽 Bandwidth Limit
docker run --device-read-bps /dev/sda:1mb nginx
docker run --device-write-bps /dev/sda:2mb nginx

🔄 IOPS Limit
docker run --device-read-iops /dev/sda:100 nginx
docker run --device-write-iops /dev/sda:100 nginx

🎚 Set Priority Weight
docker run --blkio-weight-device "/dev/sdb:600" nginx
```

---
# 🧪 Cleanup Lab
To remove **all(Running+Stopped) Docker containers** forcefully, you can use the following command:
```bash
docker rm -f $(docker ps -aq)
````
🧼 This will:
* Stop any running containers
* Remove **all** containers (both running and exited)
> ⚠️ **Warning:** This action is irreversible. Make sure you don't need any of the containers before running it!

---
## 🧪 Best Practices

- ✅ Always **set memory and CPU limits** in production.
- ✅ Use `docker stats` to monitor containers.
- ✅ Use `docker inspect` for detailed container config.
- ✅ Don’t forget about **disk I/O** and **PID** limits.

---
## 📚 Resources
* [Docker Official Docs - Resource Limits](https://docs.docker.com/config/containers/resource_constraints/)
* [Cgroups Explained](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/ch01)
* [Linux Performance Tools](https://brendangregg.com/linuxperf.html)

## 🧪 Practical Time (Try from yourself)

``` Bash
# No Swap Allowed:
docker run --memory="300m" --memory-swap="300m" ubuntu
- The container is restricted to using only 300 MB of RAM, with no swap.

# Double the Memory if Host Has Swap:
docker run --memory="300m" ubuntu
- If `--memory-swap` is not set, the container can use double the specified memory (600 MB) if the host has swap configured.

# Unlimited Swap:
docker run --memory="300m" --memory-swap=-1 ubuntu
- The container can use unlimited swap, limited only by what’s available on the host.

# --memory-swappiness`: Controlling Swap Usage
The `--memory-swappiness` option controls the tendency of the kernel to move processes out of physical memory and onto swap space.

## Low Swappiness (0):
docker run --memory-swappiness=0 ubuntu
- Minimizes swapping, keeping processes in RAM for better performance.

## High Swappiness (100):
docker run --memory-swappiness=100 ubuntu
- Allows processes to be moved to swap space more aggressively.

## --memory-reservation: Setting a Soft Limit
The --memory-reservation option sets a soft limit on the physical memory a container should ideally use. It must be set lower than the --memory limit to take precedence.
docker run --memory="500m" --memory-reservation="300m" ubuntu
- In this example, the container tries to use up to 300 MB of RAM under normal conditions but can use up to 500 MB if needed.

## Unlimited Memory, Limited Kernel Memory:
docker run --kernel-memory="200m" ubuntu
- The container has no limit on overall memory but limits the kernel memory to 200 MB.

## Limited Memory, Unlimited Kernel Memory:
docker run --memory="500m" ubuntu
- The container’s total memory is limited to 500 MB, but the kernel memory is unlimited within this limit.

## Limited Memory, Limited Kernel Memory:
docker run --memory="500m" --kernel-memory="200m" ubuntu
- Both the total memory and kernel memory are limited to ensure balanced resource usage and help debug memory issues.
```

## 🔍Inspect CPU + Memory + SWAP
```
# Inspect CPU + Memory + SWAP
docker inspect --format='Memory={{.HostConfig.Memory}} Swap={{.HostConfig.MemorySwap}} CPU={{.HostConfig.CPUShares}}' CONTAINER_NAME | awk '{printf "Memory: %.0f MB\nSwap: %.0f MB\nCPU Shares: %s\n", $1/1024/1024, $2/1024/1024, $3}'
```

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