# Minecraft server
Minecraft PaperMC Server install script on Debian

# Install
```bash
git clone https://github.com/criticalsool/minecraft-server.git
cd minecraft-server/
bash minecraft.bash
```

## First start
### Log in with minecraft user
```bash
sudo -u minecraft -s
cd /home/minecraft/minecraft
```
### Downloading the latest stable build
```bash
MINECRAFT_VERSION="1.21.4"

LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds | \
  jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]')

JAR_NAME=paper-${MINECRAFT_VERSION}-${LATEST_BUILD}.jar
PAPERMC_URL="https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"

curl -o paper.jar $PAPERMC_URL
```

### Start server
Accept eula
```bash
sed -i 's/false/true/' eula.txt
```

Start server
```bash
java -Xms4096M -Xmx4096M -jar server.jar nogui
```
> Once server is started exit by typing `stop`

### Configure
```
nano server.properties
nano bukkit.yml
nano spigot.yml
nano config/paper-global.yml
nano config/paper-world-defaults.yml
```

# Automation
## Auto restart
> As root
```bash
crontab -e
10 7 * * * systemctl restart minecraft.service
```

## Auto backup
> As minecraft user
```bash
mkdir /home/minecraft/backups
crontab -e
0 7 * * * tar -czvf /home/minecraft/backups/minecraft_backup_$(date +\%Y-\%m-\%d).tar.gz -C /home/minecraft/minecraft/world/ .
```
