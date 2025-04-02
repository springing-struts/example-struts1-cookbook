#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$(realpath "$(dirname $BASH_SOURCE)")
PROJECT_BASE_DIR=$(realpath "$SCRIPT_DIR/..")

APP_NAME=cookbook
CONTAINER_NAME=springing-struts1-$APP_NAME
DOCKER=$( (command -v podman &> /dev/null) && echo podman || echo docker )

main() {
  build && start
}

build() {
  mvn clean package -U
}

start() {
  $DOCKER build -t $CONTAINER_NAME . \
  && $DOCKER rm -f $CONTAINER_NAME \
  && $DOCKER run -d \
       -p 8080:8080 \
       -p 5005:5005 \
       --name $CONTAINER_NAME \
       --env DEBUG_PORT=5005 \
       $CONTAINER_NAME \
  && $DOCKER logs -f $CONTAINER_NAME
}

(cd "$PROJECT_BASE_DIR" \
  && eval "$(mise env)" \
  && main
)
