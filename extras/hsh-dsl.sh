#!/bin/bash

hsh() { local op=${1:-} hash=${2:-} key=${3:-} value=${4:-}
    if [ -z "$hash" ]; then
        hsh_usage
        return 1
    fi
    case $op in
        get)        hsh_check_arg key   || return 1
                    hsh_get $hash $key;;
        set)        hsh_check_arg key   || return 1
                    hsh_check_arg value || return 1
                    hsh_set $hash $key $value;;
        *)          hsh_usage
                    return 1;;
    esac
}

hsh_check_arg() { local parm=$1
    if [ -z "${!parm}" ]; then
        echo "must provide $parm with this operation!"
        return 1
    fi
    return 0
}


hsh_usage() {
    echo "Usage: op hsh some usage here"
}
