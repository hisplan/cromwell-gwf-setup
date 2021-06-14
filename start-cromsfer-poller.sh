#!/bin/bash -e

source versions.sh

docker run -it --rm -v ~/cromsfer/:/cromsfer --workdir /cromsfer \
  hisplan/cromsfer:${CROMSFER_VERSION} /usr/local/bin/cromsfer.poller --config /cromsfer/config.yaml
