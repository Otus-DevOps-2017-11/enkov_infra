#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
