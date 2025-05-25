---
created: 2025-05-25T09:03:30+05:30
updated: 2025-05-25T09:25:47+05:30
Maintainer: Ibrar Ansari
---

---
# 🚀 Day-2: Docker Images and search images.

## 🐳 What is a Docker Image?

A **Docker image** is a lightweight, standalone, and executable package that includes everything needed to run a piece of software, including the code, runtime, libraries, and dependencies. Think of it as a snapshot or blueprint of an application! 📸

- **Immutable**: Docker images are read-only templates.
- **Layered**: Built in layers for efficiency (e.g., base OS, libraries, app code).
- **Portable**: Run consistently across different environments (local, cloud, etc.).

Docker images are stored in registries like **Docker Hub**, which is like a "GitHub for Docker images." � registry

## 🔍 Why Search for Docker Images?

Searching for Docker images allows you to:
- Find pre-built images for popular software (e.g., `nginx`, `python`, `mysql`).
- Save time by reusing community-maintained or official images.
- Ensure you're using trusted and optimized images for your projects.

Docker Hub hosts millions of images, and searching efficiently helps you find the right one for your needs! 🌐

## 🚀 Steps to Work with Docker Images

1. **Install Docker**: Ensure Docker is installed and running.
2. **Search for Images**: Use the `docker search` command to find images on Docker Hub.
3. **Pull an Image**: Download the desired image to your local machine using `docker pull`.
4. **Run a Container**: Create a container from the image using `docker run`.
5. **List Images**: View all downloaded images with `docker images`.

## 📝 Example Commands

Here are some practical commands to get you started:

### 1. Search for a Docker Image
To search for an image (e.g., `nginx`):
```bash
docker search nginx
```
This lists available `nginx` images on Docker Hub, showing details like name, description, and stars. ⭐

### 2. Pull a Docker Image
To download the official `nginx` image:
```bash
docker pull nginx
```

### 3. List Local Images
To see all images on your machine:
```bash
docker images
```

### 4. Run a Container
To start a container from the `nginx` image:
```bash
docker run -d -p 8080:80 nginx
```
This runs `nginx` in the background (`-d`) and maps port `8080` on your machine to port `80` in the container.

### 5. Remove an Image
To delete an image (replace `<image_id>` with the actual ID from `docker images`):
```bash
docker rmi <image_id>
```
> [!NOTE]
> In this series of docker zero to zero I am going to use these images as well.

```bash
ibraransaridocker/network-debug-tools   latest    
ibraransaridocker/whoami                latest    
ibraransaridocker/coming-soon           latest    
ibraransaridocker/under-maintenance     latest    
ibraransaridocker/nginx-demo            latest    
ibraransaridocker/dotfiles              latest   
```
---

### Happy Dockering! 🐳✨

## 🤝 Contributing

Contributions are welcome! 🙌 If you have suggestions, improvements, or additional examples:
1. Fork this repository. 🍴
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m "Add feature"`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request. 🚀

Please ensure your contributions align with the topic of Docker images and searching by name.

### 💼 Connect with me 👇👇 😊

- 🔥 [**Youtube**](https://www.youtube.com/@DevOpsinAction?sub_confirmation=1)
- ✍ [**Blog**](https://ibraransari.blogspot.com/)
- 💼 [**LinkedIn**](https://www.linkedin.com/in/ansariibrar/)
- 👨‍💻 [**Github**](https://github.com/meibraransari?tab=repositories)
- 💬 [**Telegram**](https://t.me/DevOpsinActionTelegram)
- 🐳 [**Docker**](https://hub.docker.com/u/ibraransaridocker)

# Hit the Star! ⭐
***If you are planning to use this repo for learning, please hit the star. Thanks!***
****