#!/bin/bash

docker buildx build --no-cache --platform linux/amd64 -t website:latest .

docker save website:latest -o website.tar

scp website.tar apprentice:~/website.tar

# SSH into the remote server to update the Docker container
ssh apprentice << 'EOF'
  sudo docker load -i ~/website.tar

  rm ~/website.tar

  # Stop and remove the old container if it exists
  sudo docker stop website-container
  sudo docker rm -f website-container || true

  # Run the new container
  sudo docker run -d --name website-container --restart=unless-stopped -p 8080:8080 website:latest

  sudo systemctl restart caddy
EOF

# remove locally
rm website.tar
