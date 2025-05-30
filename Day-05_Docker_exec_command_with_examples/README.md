---
created: 2025-05-29T21:33:09+05:30
updated: 2025-05-30T06:34:55+05:30
Maintainer: Ibrar Ansari
---
# 🐳 **Day 5: Mastering docker exec Command - With examples!**

Welcome to this **Docker tutorial**! In this guide, we cover the **`docker exec` command**. Whether you're new to Docker or just need a refresher, this will help you understand how to run commands inside a running container. Let's dive in! 🎯


<!--
## 🎬 Video Demonstration
[![Watch on Youtube](https://i.ytimg.com/vi/TXIQYO21ais/maxresdefault.jpg)](https://youtu.be/TXIQYO21ais)

-->

## 📌 1. What is `docker exec`?

The `docker exec` command allows you to **run a command in a running container**.

> 🧠 It's like opening a terminal **inside your container**!

### ❔ Get Help using help command
```
docker exec --help
```
```
Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

Execute a command in a running container

Aliases:
  docker container exec, docker exec

Options:
  -d, --detach               Detached mode: run command in the background
      --detach-keys string   Override the key sequence for detaching a container
  -e, --env list             Set environment variables
      --env-file list        Read in a file of environment variables
  -i, --interactive          Keep STDIN open even if not attached
      --privileged           Give extended privileges to the command
  -t, --tty                  Allocate a pseudo-TTY
  -u, --user string          Username or UID (format: "<name|uid>[:<group|gid>]")
  -w, --workdir string       Working directory inside the container

```

## ❓ 2. Why Use `docker exec`?

Here are some common reasons to use `docker exec`:

- 🐞 **Debugging**: Access a container’s shell to troubleshoot issues.
- 🔍 **Inspection**: Check files, processes, or environment variables inside a container.
- 🛠️ **Management**: Run one-off commands or scripts without modifying the container’s image.
- 🗨️ **Interactivity**: Start an interactive session (e.g., a bash shell) to work inside the container.

## 🛠️ 3. Syntax

```
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
````

* **CONTAINER**: The name or ID of the running container (find it using `docker ps`).
* **COMMAND**: The command you want to run inside the container.
* **ARG**: Optional arguments for the command.
* **OPTIONS**:

  * `-i`, `--interactive`: Keep STDIN open.
  * `-t`, `--tty`: Allocate a pseudo-TTY.
  * `-d`, `--detach`: Run the command in the background.
  * `-u`, `--user`: Run the command as a specific user.
  * `-e`, `--env`: Set environment variables.
  * `--workdir`: Set the working directory inside the container.

## Summery
### 🧩 -i → Interactive
- Keeps STDIN (standard input) open even if not attached.
- Allows you to send input to the container, such as typing commands or piping input.

### 🖥️ -t → TTY (Pseudo-TTY)
- Allocates a pseudo-terminal.
- Makes the session act like a real terminal — this enables features like:
  - Colored output
  - Line editing
  - Clear formatting

### Test Case
```
docker exec -i — you can pipe input in, but the terminal behaves oddly.
docker exec -t — may hang, since it expects interactive input.
docker exec -it ubuntu apt update -y

```
## 🚀 4. Basic Example

Check the current directory inside the container:

```
docker exec ubuntu pwd
```

➡️ **Use Case**: Quickly verify the working directory or check system details.

## 🖥️ 5. Open an Interactive Shell

To start a bash shell inside the container:

```
docker exec -it ubuntu bash
docker exec -it alpine bash
```

🔁 If `bash` isn't available, try `sh`:

```
docker exec -it alpine sh
```

## 🔒 6. Run as a Specific User

Run a command as the `root` user:

```
docker exec -u root ubuntu whoami
```

➡️ **Use Case**: Perform actions requiring elevated permissions.

## 📜 7. Run a Script Inside the Container

To run a script in the background:

```
docker exec -it ubuntu /root/setup.sh
```

➡️ **Use Case**: Execute long-running tasks without tying up your terminal.

## 🌱 8. Set Environment Variables

Set an environment variable for the command:

```
docker exec -e user=postgres ubuntu env
```

➡️ **Use Case**: Test how environment variables affect a command.

## 📂 9. Run a Command in a Specific Directory

Run a command in a specific working directory:

```
docker exec --workdir /root ubuntu pwd
docker exec --workdir /root ubuntu ls -alsh
```

➡️ **Use Case**: Execute commands in a specific directory without altering container defaults.

## ✅ 10. Best Practices

* ✅ Always use `-it` for interactive commands.
* ✅ Ensure your container is **running** before executing commands.
* ✅ Use `docker ps` to check container status.
* ❌ Avoid running long-lived processes via `exec` — it's for one-off tasks.

---
## 🔗 Additional Resources

* 📘 [Official Docker `exec` Documentation](https://docs.docker.com/reference/cli/docker/container/exec/)
* 🧰 [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
* 🐋 [Docker Hub](https://hub.docker.com/)

---

Happy Docking! 🐳💻

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