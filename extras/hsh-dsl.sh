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
        del)        hsh_del $hash $key;;
        keys)       hsh_keys $hash;;
        size)       hsh_size $hash;;
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

hsh_attempt_del() { local hash=$1 key=${2:-}
    local before_size=$(hsh_size $hash)
    hsh_del $hash $key
    local after_size=$(hsh_size $hash)
    if [ $before_size -gt $after_size ]; then
        return 0
    else
        return 1
    fi
}

hsh_attempt_keys() { local hash=$1
    local keys=$(hsh_keys $hash)
    if [ -z "$keys" ]; then
        return 1
    else
        echo "$keys"
        return 0
    fi
}

hsh_attempt_size() { local hash=$1
    local size=$(hsh_size $hash)
    if [ -z "$size" ]; then
        return 1
    else
        echo "$size"
        return 0
    fi
}

hsh_usage() {
    echo "Usage: hsh op hashname [key] [value]"
    echo "   where op is one of:"
    echo "   get   :requires key argument"
    echo "   set   :requires key and value arguments"
    echo "   del   :requires key and/or value arguments"
    echo "   keys"
}
