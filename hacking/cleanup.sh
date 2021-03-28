#!/usr/bin/env bash

rm -rf ansible_collections
# Need to install the collection into ~/.ansible to test roles, see test_roles.sh
rm -rf ~/.ansible/collections/ansible_collections/maxhoesel/pterodactyl

rm -rf .cache
