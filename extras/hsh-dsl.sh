#!/bin/bash

hsh() { local op=${1:-} hash=${2:-} key=${3:-}
    if [ -z "$hash" ]; then
        echo "Usage: op hsh some usage here"
    fi
    case $op in
        get)        hsh_enforce_parameter key
                    hsh_get $hash $key;;
        set)        hsh_enforce_parameter key
                    :;;
    esac
}


