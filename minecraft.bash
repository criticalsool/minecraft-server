#! /bin/bash

# Install needed packages
apt-get update
apt-get install -y curl ca-certificates apt-transport-https gnupg wget ufw jq nano

# Configure firewall
ufw allow 25565/tcp
ufw default deny incoming
ufw default deny forward
ufw enable

# Install corretto source
wget -O - https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | tee /etc/apt/sources.list.d/corretto.list

# Install java
apt-get update
apt-get install -y java-21-amazon-corretto-jdk libxi6 libxtst6 libxrender1

# Add minecraft user
useradd -m minecraft

# Add server folder
mkdir /home/minecraft/minecraft
chown minecraft: /home/minecraft/minecraft
chmod o-rwx /home/minecraft/minecraft

# Install minecraft service
cat > /etc/systemd/system/minecraft.service <<'EOF'
# /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft PaperMC Server
Wants=network-online.target
After=network-online.target
[Service]
User=minecraft
WorkingDirectory=/home/minecraft/minecraft
ExecStart=/usr/bin/java -Xms4096M -Xmx4096M -jar server.jar nogui
Restart=always
# Do not remove this!
StandardInput=null
[Install]
WantedBy=multi-user.target
EOF

# Enable minecraft service at startup
systemctl enable minecraft
