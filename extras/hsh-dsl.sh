#!/bin/bash

hsh() { local op=${1:-} hash=${2:-} key=${3:-}
    if [ -z "$hash" ]; then
        echo "Usage: op hsh some usage here"
    fi
    case $op in
        get)    if [ -z "$key" ]; then
                    echo "must provide key with $op operation!"
                    exit 1
                else
                    hsh_get $hash $key
                fi;;
    esac
}


