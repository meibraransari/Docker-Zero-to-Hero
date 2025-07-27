# 🏗️ Base stage for builder
FROM python:3.10-slim AS builder

# ⚙️ Build-time argument
ARG INSTALL_ENV=prod

# 🧨 ONBUILD trigger for child Dockerfiles
ONBUILD RUN echo "This is a base image with ONBUILD trigger."

# 🐚 Set default shell
SHELL ["/bin/bash", "-c"]

# 📦 Add external or archive files
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh

# 📁 Copy app files
COPY ./app /app

# 🏷️ Labels for metadata
LABEL maintainer="DevOps In Action"
LABEL version="1.0"
LABEL description="A Docker image demonstrating all instructions"

# 🌍 Environment variables
ENV APP_HOME=/app \
    FLASK_ENV=development

# 📂 Working directory
WORKDIR $APP_HOME

# 🔧 Install dependencies
RUN apt-get update && \
    apt-get install -y curl iputils-ping && \
    pip install flask && \
    chmod +x /wait-for-it.sh

# 💾 Define a volume
VOLUME ["/data"]

# 🛠️ Default command
CMD ["python", "main.py"]

# 🚪 Set entrypoint
ENTRYPOINT ["python", "main.py"]

# 🛑 Graceful shutdown signal
STOPSIGNAL SIGINT

# 👥 Run as root (default in most cases, explicitly shown)
USER root

# 📡 Expose port
EXPOSE 5000

# 🩺 Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
  CMD curl -f http://localhost:5000/ping || exit 1
