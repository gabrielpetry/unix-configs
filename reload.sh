#!/bin/sh
set -eo pipefail

cd "$1"

git reset --hard HEAD
git pull origin main
