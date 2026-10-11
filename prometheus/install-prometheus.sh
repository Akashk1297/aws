#!/bin/bash
set -euo pipefail

# Prometheus version
VERSION="3.4.0"
ARCH="linux-amd64"

if [ `uname` == 'Linux' ];then
    printf 'Linux kernel'
else
    printf 'Kernel not supported'
    exit 1
fi

prometheus --version
if [ `echo $?` -eq 0 ];then
    printf 'Prometheus already setup'
    exit 0
else
    printf 'Prometheus not installed. Proceeeding...'
fi

# Create a dedicated system user
if ! id prometheus &>/dev/null; then
    sudo useradd --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        prometheus
fi

# Create required directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download and extract Prometheus
cd /tmp
wget -O "prometheus-${VERSION}.${ARCH}.tar.gz" \
    "https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.${ARCH}.tar.gz"

tar -xzf "prometheus-${VERSION}.${ARCH}.tar.gz"
cd "prometheus-${VERSION}.${ARCH}"

# Install binaries
sudo install -m 0755 prometheus /usr/local/bin/prometheus
sudo install -m 0755 promtool /usr/local/bin/promtool

# Install configuration and console files
sudo cp prometheus.yml /etc/prometheus/
#sudo cp -r consoles /etc/prometheus/
#sudo cp -r console_libraries /etc/prometheus/

# Set ownership and permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Create systemd service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Validate configuration
sudo /usr/local/bin/promtool check config \
    /etc/prometheus/prometheus.yml

# Enable and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus

# Check service status
sudo systemctl status prometheus --no-pager

op=`curl -s -o /dev/null -w "%{http_code}\n" https://example.com`
if [ $op -eq 200 ];then
    printf 'Prometheus install unsuccessful'
else    
    printf 'Prometheus install successful'
fi
