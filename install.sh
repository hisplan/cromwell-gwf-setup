#!/bin/bash -e

source versions.sh

# start docker 
sudo service docker start

docker pull redis:${REDIS_VERSION}
docker pull hisplan/cromsfer:${CROMSFER_VERSION}

echo "DONE"
