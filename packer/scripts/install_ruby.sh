#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

apt update
apt install -y ruby-full ruby-bundler build-essential
