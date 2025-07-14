---
Created: 2025-07-13T07:30:35+05:30
Updated: 2025-07-13T07:33:45+05:30
Maintainer: Ibrar Ansari
---

# 🐳 Day 16: What is Docker Images

A **Docker Image** is a lightweight, standalone, and executable software package that includes **everything needed to run a piece of software**:
👉 Code, runtime, libraries, environment variables, and configuration files.

### 📌 In Simple Terms:

> **Docker Images are templates used to create Docker Containers.**

When you use an image, Docker launches **containers**, which are running instances of those images.

---

## 🎬 Video Demonstration

[![Watch on Youtube](https://i.ytimg.com/vi/lDTsQn2zw18/maxresdefault.jpg)](https://youtu.be/lDTsQn2zw18)

---

## 🗂️ Docker Images vs Containers

| Component     | Description                                             |
| ------------- | ------------------------------------------------------- |
| **Image**     | Template that contains app code + dependencies + config |
| **Container** | A running instance of an image                          |
| **Stored In** | Registries like [Docker Hub](https://hub.docker.com)    |

---

# 🏷️ Docker Image Tags Summary

Below is a reference table of commonly used Docker image tags, their base OS, sizes, and typical use cases.

| Tag                       | OS Base           | Size       | libc    | Use Case                                                |
| ------------------------- | ----------------- | ---------- | ------- | ------------------------------------------------------- |
| **alpine**                | Alpine Linux      | \~5–10MB   | musl    | 🪶 Smallest image, great for minimal environments       |
| **bookworm**              | Debian 12         | \~100MB    | glibc   | 📦 Latest Debian, full ecosystem                        |
| **bookworm-slim**         | Debian 12 Slim    | \~20–50MB  | glibc   | 🚀 Lightweight Debian 12                                |
| **bullseye**              | Debian 11         | \~100MB    | glibc   | ✅ Modern Debian, stable environment                     |
| **bullseye-slim**         | Debian 11 Slim    | \~20–50MB  | glibc   | ⚙️ Smaller Debian 11 image                              |
| **buster**                | Debian 10         | \~80MB     | glibc   | 🧱 For compatibility with older packages                |
| **busybox**               | BusyBox           | \~1–5MB    | musl    | 🧰 Basic Unix tools in smallest footprint               |
| **centos**                | CentOS 7/8        | \~200MB    | glibc   | 🏢 RHEL-compatible, common in enterprise setups         |
| **current**               | Varies            | Varies     | Varies  | 🔄 Pulls latest Node.js image without specific variant  |
| **current-alpine**        | Alpine Linux      | \~5–10MB   | musl    | 🌱 Lightweight Node.js with latest Alpine               |
| **current-alpine3.20**    | Alpine Linux 3.20 | \~5–10MB   | musl    | 🔧 Use specific Alpine version for consistency          |
| **current-bookworm**      | Debian 12         | \~100MB    | glibc   | 🧪 Latest Debian + Node.js                              |
| **current-bookworm-slim** | Debian 12 Slim    | \~20–50MB  | glibc   | 🧼 Minimal Debian 12 + Node.js                          |
| **current-bullseye**      | Debian 11         | \~100MB    | glibc   | 🔁 Stable base with Node.js                             |
| **current-bullseye-slim** | Debian 11 Slim    | \~20–50MB  | glibc   | 📉 Minimal Debian 11 + Node.js                          |
| **current-slim**          | Debian Slim       | \~20–50MB  | glibc   | 🐾 Lightweight Node.js, good for production builds      |
| **focal**                 | Ubuntu 20.04      | \~70MB     | glibc   | 🔐 LTS, older Ubuntu with package stability             |
| **jammy**                 | Ubuntu 22.04      | \~70MB     | glibc   | 📦 Broad package support, current LTS                   |
| **latest**                | Varies            | Varies     | Varies  | 🔔 Pulls latest stable version of Node.js               |
| **noble**                 | Ubuntu 24.04      | \~70MB     | glibc   | 🌟 Latest Ubuntu with newest packages                   |
| **scratch**               | None              | \~0MB      | None    | ⚙️ Base for minimal, binary-only images (e.g., Go apps) |
| **slim**                  | Debian Slim       | \~20–50MB  | glibc   | ✂️ Minimized image, good for production                 |
| **ubi**                   | Red Hat UBI       | \~80–150MB | glibc   | 🛡️ Enterprise-grade, RHEL-compliant base image         |
| **windows**               | Windows Core      | >200MB     | Windows | 🪟 Windows containers support                           |

---

## 🧠 Notes

* **libc**:

  * `musl` is lightweight but has limited compatibility (e.g., Alpine, BusyBox).
  * `glibc` is standard and widely supported.
  * `scratch` has no libc.
  * `windows` uses native Windows system libraries.

* **Size**: Estimates only; will increase as app layers are added.

* **Variants**:

  * `slim`: Reduces image size, fewer preinstalled packages.
  * `alpine`: Excellent for small, secure, minimal containers.
  * `scratch`: For building absolute minimal containers from nothing.

---

# 🧪 Choosing the Right Node.js Image Tag

To pull a specific Node.js image:

```bash
docker pull node:<tag-name>
```

| Tag                     | Description                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `latest`                | Stable Node.js release with full feature set                 |
| `current`               | Latest Node.js release available (may include non-LTS)       |
| `slim`                  | Reduced Node.js image with minimal dependencies              |
| `current-slim`          | Latest Node.js + slim base                                   |
| `current-bullseye`      | Latest Node.js on full Debian Bullseye                       |
| `current-bullseye-slim` | Latest Node.js on Debian Bullseye Slim                       |
| `current-bookworm`      | Latest Node.js on full Debian Bookworm                       |
| `current-bookworm-slim` | Latest Node.js on Debian Bookworm Slim                       |
| `current-alpine`        | Latest Node.js on Alpine (smallest option)                   |
| `current-alpine3.20`    | Node.js on Alpine 3.20 (specific version for predictability) |

---

## 🔍 Where to Explore More

* [Ubuntu Tags on Docker Hub](https://hub.docker.com/_/ubuntu/tags)
* [Debian Tags on Docker Hub](https://hub.docker.com/_/debian/tags)
* [Node.js Tags on Docker Hub](https://hub.docker.com/_/node/tags)

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
