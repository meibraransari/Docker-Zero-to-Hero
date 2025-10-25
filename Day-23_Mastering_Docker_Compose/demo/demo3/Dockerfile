#Dockerfile
FROM nginx:latest
RUN echo "alias ll='ls -alsh --color=auto'" >> /etc/bash.bashrc
RUN apt-get update && \
    apt-get install -y htop iputils-ping net-tools dnsutils traceroute && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 80
