#!/bin/bash

hsh() { local op=${1:-} hash=${2:-} key=${3:-} value=${4:-}
    if [ -z "$hash" ]; then
        hsh_usage
        return 1
    fi
    case $op in
        get)        hsh_enforce_parameter key
                    hsh_get $hash $key;;
        set)        hsh_enforce_parameter key
                    hsh_enforce_parameter value
                    hsh_set $hash $key $value;;
        ?)          hsh_usage
                    exit 1;;
    esac
}

hsh_enforce_parameter() { local parm=$1
    if [ -z "${!parm}" ]; then
        echo "must provide $parm with this operation!"
        exit 1
    fi
}

hsh_usage() {
    echo "Usage: op hsh some usage here"
}
