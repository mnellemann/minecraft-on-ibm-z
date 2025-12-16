#!/bin/bash -x

###
### Install Minecraft Server, Tested on Ubuntu 22.04
###

MINECRAFT_DIR=/home/minecraft
MINECRAFT_USER=minecraft


# Install dependencies
apt update
apt install -y openjdk-21-jre-headless wget curl jq

# Create user account
useradd --comment "Minecraft Server" --create-home ${MINECRAFT_USER}

# Download vanilla minecraft server 1.21.11
if [ ! -f "${MINECRAFT_DIR}/minecraft.jar" ]; then
  su -l -c "curl -o minecraft.jar https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar" ${MINECRAFT_USER}
fi

# Accept EULA
if [ ! -f "${MINECRAFT_DIR}/eula.txt" ]; then
  su -l -c "java -Xms1024M -Xmx1024M -jar ./minecraft.jar nogui"  ${MINECRAFT_USER}
  sed -i s/eula=false/eula=true/g ${MINECRAFT_DIR}/eula.txt
fi

# Install system service
if [ ! -f "/etc/systemd/system/minecraft.service" ]; then
cat << EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=${MINECRAFT_DIR}
User=${MINECRAFT_USER}
Nice=5
ExecStart=/usr/bin/java -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar "${MINECRAFT_DIR}/minecraft.jar" nogui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable minecraft.service
fi

# Start service
systemctl start minecraft.service
