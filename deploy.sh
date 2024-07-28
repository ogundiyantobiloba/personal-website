#!/bin/bash

# Login to DigitalOcean Container Registry
doctl registry login

# Build the Docker image without using cache and push it to the registry
docker buildx build --no-cache --platform linux/amd64 -t registry.digitalocean.com/apprentice/website:latest --push .

# SSH into the remote server to update the Docker container
ssh -i ~/.ssh/id_rsa root@138.68.181.207 << EOF
  # Login to DigitalOcean Container Registry
  doctl registry login

  # Pull the latest Docker image from the registry
  docker pull registry.digitalocean.com/apprentice/website:latest

  # Stop and remove the old container if it exists
  docker stop website-container
  docker rm -f website-container || true

  # Run the new container
  docker run -d --name website-container --restart=unless-stopped -p 8080:8080 registry.digitalocean.com/apprentice/website:latest
EOF
