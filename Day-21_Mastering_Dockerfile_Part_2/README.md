# 🐳 Day 21:  Mastering Dockerfile⚔ Part 2 – Dockerfile Build Nginx, PHP 8.1 and Init Base Image for Your Project


### 🎯 What’s a Base Image?

A **base image** is the **starting point** for your Docker image.  
It defines the **initial environment** your application runs in — like the operating system, runtime, or pre-installed tools.

Think of it as the **foundation of your Docker house**.  
You’ll build everything like required app, dependencies config etc except (code).


## 💡 Why the Base Image Matters

| Benefit | Description |
|----------|--------------|
| 🧩 **Consistency** | Every environment (dev, test, prod) starts from the same setup. |
| ⚡ **Speed** | Using official prebuilt images reduces build time. |
| 🛡️ **Security** | Official images are maintained with security updates. |
| 🧰 **Simplicity** | You focus on your app, not system setup. |
| 🚀 **Reusability** | Custom base images can be shared across multiple projects. |


## 🚀 Demo Time
- Build and push a custom NGINX base image to a private Docker Hub repository, then test deployment.
	- Single script file which create config and build docker base image and and pust to repo - Ready to use
- Build and push a PHP 8.1 base image, verify functionality with a sample app.
	- Multiple file with script to build docker base image and and pust to repo - Ready to use
- Create a Node.js-based init container image, push to private repo.
	- Single script file which create config and build docker base image and and pust to repo - After run it setup app and config


```
git clone https://github.com/meibraransari/Docker-Zero-to-Hero.git
cd Docker-Zero-to-Hero/Day-21_Mastering_Dockerfile_Part_2/
# Build Init Image
cd init/
bash init_base.sh
# Build Nginx Image
cd nginx/
bash nginx_web_base.sh
# Build PHP Image
cd php/
bash build_image.sh
```
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



