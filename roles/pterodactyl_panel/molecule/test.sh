#!/usr/bin/env bash

set -eu
set -o pipefail

CONTAINERS=(
    "ubuntu2004"
)

for ct in "${CONTAINERS[@]}"; do
    PTERODACTYL_CONTAINER="$ct" molecule test
done
