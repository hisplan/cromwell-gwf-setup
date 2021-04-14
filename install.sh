#!/bin/bash -e

source versions.sh

dicker pull redis:${REDIS_VERSION}
docker pull hisplan/cromsfer:${CROMSFER_VERSION}

echo "DONE"
