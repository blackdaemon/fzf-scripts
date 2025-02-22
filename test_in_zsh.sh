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

print_help() {
  cat << EOF

Usage:
  $(basename "$0") [-v|verbose|-n|--no-negative] [source_date] <target_date>

Example:
  Print number of days remaining to Christmas:
    $(basename "$0") -v "Dec 24"
EOF
}

# -allow a command to fail with !'s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
# shellcheck disable=SC2251
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'Sorry, "getopt --test" failed in this environment.'
    exit 1
fi

OPTIONS=vh\?d
LONGOPTS=verbose,help,debug

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
# shellcheck disable=SC2251,SC2086
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# Initialize our own variables:
VERBOSE=
DEBUG=

while true; do
    case "$1" in
        -\?|-h|--help)
	    print_help
	    exit 0
	    ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -d|--debug)
            DEBUG=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done
echo $VERBOSE $DEBUG > /dev/null

# Build the Docker image
docker build -t zsh-fzf-test -f Dockerfile.zsh .

# Run the container in interactive mode with a TTY
docker run --rm -it zsh-fzf-test

