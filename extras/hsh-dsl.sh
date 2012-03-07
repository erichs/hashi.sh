#!/bin/bash

hsh() { local op=${1:-} hash=${2:-}
    if [ -z "$hash" ]; then
        echo "Usage: op hsh some usage here"
    fi
}
