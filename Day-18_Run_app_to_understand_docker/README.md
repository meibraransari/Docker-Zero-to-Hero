### 📦🚀 **Run Python Apps in Docker Without Building Images(Understand basic Requirement)**

*Temporary Containers for Fast Testing & Development*

> 🔧 Great for local development, debugging, and quick iterations without writing a Dockerfile!

## 🎬 Video Demonstration

[![Watch on Youtube](https://i.ytimg.com/vi/wRwvoKsCMas/maxresdefault.jpg)](https://youtu.be/wRwvoKsCMas)

---
## Method 1: 🐍Traditional way to run Python 
```
# app.py

from http.server import SimpleHTTPRequestHandler, HTTPServer

HOST = '0.0.0.0'
PORT = 8000

class MyHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        print(f"Received GET request for: {self.path}")
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from 🐍 Python Traditional & inside Docker!\n")

if __name__ == '__main__':
    print(f"Starting server on {HOST}:{PORT}")
    httpd = HTTPServer((HOST, PORT), MyHandler)
    httpd.serve_forever()
```

python3 app.py

## Method 2: 🔄 For Interactive Python (Debugging) Session 

```bash
docker run -itd \
  --name=debug \
  -v $(pwd):/app \
  -w /app \
  -p 8000:8000 \
  python:3.8 \
  /bin/bash
```

💡 Use this for debugging or trying out code quickly inside the container.
📁 `-w` sets the working directory so your script can run as if it's local.

## Method 3: ✅ Basic Example (No Dockerfile Needed)

```bash
drm debug
docker run -itd \
  --name=debug \
  -v $(pwd):/app \
  -w /app \
  -p 8000:8000 \
  python:3.8 \
  python /app/app.py
```

📝 This mounts your current directory to `/app` in the container and directly runs your Python script.

---

## Method 4: 🔁 With Requirements Installation

mkdir app && cd app

nano requirements.txt
```
flask
```

nano app.py
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask inside Docker!\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001)
```


```bash
docker run -itd \
  --name=testpy \
  -p 8001:8001 \
  -v $(pwd):/app \
  python:3.8 \
  /bin/bash

drm testpy
docker run -itd \
  --name=testpy \
  -p 8001:8001 \
  -v $(pwd):/app \
  python:3.8 \
  bash -c "pip install -r /app/requirements.txt && python /app/app.py"
```

📦 Useful if your app has dependencies but you don't want to build an image.

---

# Dockerfile

- A **Dockerfile** is a recipe to create Docker images for Dev/QA/UAT and Production.  
- It contains the **instructions** to build the images.  
- A Dockerfile is a **plain text file**.

---

## What we will cover in the next video:

We will **create our first Dockerfile**.


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
