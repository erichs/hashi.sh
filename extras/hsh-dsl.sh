#!/bin/bash

hsh() { local op=${1:-}
    if [ -z "$op" ]; then
        __usage
        return 1
    fi
    for method in $(__methods); do
        if [ "hsh_$op" == $method ]; then
            $($method)
            return $?
        fi
    done
    __usage
    return 1
}

__usage() {
    echo "Usage: hsh op hashname [key] [value]"
    echo "   where op is one of:"
    local prefix="hsh_"
    for method in $(__methods); do
        echo "   ${method#$prefix}"  # auto-generate op list
    done
}
