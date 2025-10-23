# 🐳 Day 22:  Mastering Dockerfile⚔ Part 3 – Dockerfile Build Nginx, PHP 8.1 Sample App Image for Your Project

## 🎯 **Goal**

In this session, we’ll build and deploy two custom Docker images:

1. 🧩 **Password Generator App**
   Built using the base image 👉 `hub.devopsinaction.lab/base/nginx_web_base`

2. 🧪 **PHP Info App**
   Built using the base image 👉 `hub.devopsinaction.lab/base/php81_web_base`


## 🎬 Video Demonstration

[![Watch on Youtube](https://i.ytimg.com/vi/6_qmsH2S4M/maxresdefault.jpg)](https://youtu.be/6_qmsH2S4M)


## 🚀 **Demo Overview**

### 🔹 Step 1: Build & Push a Custom NGINX App Image

* Use the `nginx_web_base` image as the foundation.
* Integrate your **Password Generator** web application.
* Tag and push the final image to your **private Docker Hub** repository.
* Test deployment to verify NGINX is serving the app correctly.

### 🔹 Step 2: Build & Push a PHP 8.1 App Image

* Use the `php81_web_base` image as the foundation.
* Deploy a **sample PHP app** (e.g., `phpinfo()` page) to verify PHP configuration and functionality.
* Tag and push the image to your private registry.
* Run the container and confirm output in the browser.


## 🧰 **Key Takeaways**

* Understand how to **extend base images** for application-specific needs.
* Learn how to **build, tag, and push** images to a private registry.
* Verify that your containers run successfully using **NGINX and PHP 8.1**.

```
git clone https://github.com/meibraransari/Docker-Zero-to-Hero.git
cd Docker-Zero-to-Hero/Day-22_Mastering_Dockerfile_Part_3/
bash init_base.sh
# Build Nginx Image
cd nginx/
bash build_nginx_app.sh
# Build PHP Image
cd php/
bash build_php_app.sh
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



