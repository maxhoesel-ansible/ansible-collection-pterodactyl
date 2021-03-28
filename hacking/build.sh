#!/usr/bin/env bash

# Remove previous test installs
rm -r ansible_collections

# Remove old built versions
rm maxhoesel-pterodactyl-*.tar.gz

ansible-galaxy collection build --force .

ansible-galaxy collection install maxhoesel-pterodactyl-*.tar.gz -p .
