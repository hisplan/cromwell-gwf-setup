#!/bin/bash -e

source versions.sh

docker pull redis:${REDIS_VERSION}
docker pull hisplan/cromsfer:${CROMSFER_VERSION}

echo "DONE"
