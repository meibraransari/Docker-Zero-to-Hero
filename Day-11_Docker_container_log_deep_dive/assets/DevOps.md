---
created: 2025-06-11T10:42:25+05:30
updated: 2025-06-11T18:35:05+05:30
---

## 🛡 Best Practices for Production Logging


1. **Use Centralized Logging**: Avoid storing logs on the host; use Fluentd, ELK, or CloudWatch.
2. **Enable Log Rotation**: Prevent disk space issues with `max-size` and `max-file`.
3. **Monitor Log Volume**: Set up alerts for unusual log activity (e.g., excessive errors).
4. **Secure Logs**: Ensure logs are encrypted in transit (e.g., TLS for Fluentd).
5. **Standardize Log Formats**: Use structured logging (JSON) for easier parsing.
6. **Integrate with Monitoring**: Combine logs with metrics (e.g., Prometheus) for holistic observability.

### 🧭 Choose the Right Driver:

* Use `fluentd`, `gelf`, or `syslog` for centralized logging.
* Avoid `json-file` in high-scale production setups.

### 🗃 Centralized Logging Stack:

Use tools like:

* 📊 **ELK Stack** (Elasticsearch, Logstash, Kibana)
* 🌊 **EFK Stack** (Elasticsearch, Fluentd, Kibana)
* 📈 **Promtail + Loki + Grafana**
* 🛠 **Datadog / Splunk / NewRelic**

### 🧯 Log Parsing & Enrichment:

* Add structured logs in **JSON format**.
* Include metadata: container name, service name, environment, etc.


### Centralized Logging with Fluentd or ELK Stack 📦

For production environments, centralizing logs is critical for monitoring and analysis. Popular tools include:

- **Fluentd**: A lightweight log collector that integrates with Docker.
- **ELK Stack (Elasticsearch, Logstash, Kibana)**: A powerful solution for log storage, processing, and visualization.

#### Example: Setting Up Fluentd Logging

```bash
1. Run a Fluentd container:
    docker run -d --name fluentd -p 24224:24224 fluent/fluentd    
2. Configure Docker to use Fluentd logging driver:
    docker run --log-driver=fluentd --log-opt fluentd-address=localhost:24224 --name my-app nginx
3. Fluentd configuration (`fluent.conf`):
    <source>
      @type forward
      port 24224
    </source>
    <match docker.**>
      @type elasticsearch
      host elasticsearch
      port 9200
      logstash_format true
    </match>
4. Visualize logs in Kibana or another dashboard.
```    

### AWS CloudWatch Logs ☁️

For cloud-based deployments, Docker supports the `awslogs` driver to send logs to AWS CloudWatch.

**Prerequisites**:

- AWS CLI configured with credentials.
- CloudWatch log group created

```bash
docker run \
  --log-driver=awslogs \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-group=my-log-group \
  --log-opt awslogs-stream=my-container \
  --name my-app nginx
```

.

### Log Rotation and Management 🔄

To prevent disk space issues, configure log rotation:

- Use `max-size` and `max-file` with `json-file` or `local` drivers.
- Implement external tools like `logrotate` for host-level log management.

**Example with `logrotate`**:

```bash
/var/lib/docker/containers/*/*.log {
  daily
  rotate 7
  compress
  delaycompress
  missingok
  notifempty
}


# Run `logrotate` daily:
sudo logrotate /etc/logrotate.d/docker
```

### Structured Logging with Labels 🏷️

Add metadata to logs using Docker labels for better filtering and searching:

```bash
docker run -d --label "app=nginx" --label "env=prod" --name my-app nginx
```

Filter logs in tools like Fluentd or ELK using these labels.

### #### **Automating Log Cleanup in Jenkins**
```bash
pipeline {
    agent any
    stages {
        stage('Clean Logs') {
            steps {
                sh 'docker system prune -f'
                sh 'truncate -s 0 /var/lib/docker/containers/*/*-json.log'
            }
        }
    }
}
```

### Automating Log Cleanup in GitHub Actions
```
name: CI Cleanup
on:
  push:
    branches:
      - main

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Clean Docker logs
        run: |
          sudo truncate -s 0 /var/lib/docker/containers/*/*-json.log
          docker system prune -f
```