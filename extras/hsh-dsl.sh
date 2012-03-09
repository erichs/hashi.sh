#!/bin/bash

hsh() { local op=${1:-} hash=${2:-} key=${3:-} value=${4:-}
    if [ -z "$hash" ]; then
        __usage
        return 1
    fi
    case $op in
        get)        __check_args key   || return 1
                    hsh_get $hash $key;;
        set)        __check_args key value  || return 1
                    hsh_set $hash $key $value;;
        del)        hsh_del $hash $key;;
        keys)       hsh_keys $hash;;
        size)       hsh_size $hash;;
        *)          __usage
                    return 1;;
    esac
}

__usage() {
    echo "Usage: hsh op hashname [key] [value]"
    echo "   where op is one of:"
    echo "   get   :requires key argument"
    echo "   set   :requires key and value arguments"
    echo "   del   :requires key and/or value arguments"
    echo "   keys"
}
