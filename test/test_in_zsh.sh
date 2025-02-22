#!/bin/bash
# vim:set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:
#
# test_in_zsh.sh
# Copyright (C) 2025 Pavel Vitis <pavelvitis@gmail.com>
#
# Distributed under terms of the MIT license.
#

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

if [ "$(basename $PWD)" == "test" ]; then
  cd ..
fi 

project_dir=$PWD

cd test

# Build the Docker image
docker build -t zsh-script-test -f Dockerfile.zsh .

# Run the container in interactive mode with a TTY
docker run --rm -it -v "$project_dir/scripts:/root/scripts" zsh-script-test

