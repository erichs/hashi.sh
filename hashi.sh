#!/bin/bash
# hashi.sh - ultra-simple key/value hash

set -e

hsh_escape_key() { local key=$1
    echo ${key//-/___}  # bash doesn't allow hyphens in variable names. bummer.
}

hsh_set() { local hash=$1 key=$2 val=$3
    local fullkey=$(hsh_escape_key "__${hash}_${key}")
    eval "$fullkey='$val'"
}

hsh_get() { local hash=$1 key=$2
    local fullkey=$(hsh_escape_key "__${hash}_${key}")
    echo ${!fullkey:-}  # the {foo:-} idiom is safe to use with set -o nounset | set -u
}

hsh_keys() { local hash=$1
    local prefix="__${hash}_"
    local vars
    eval vars="\${!$prefix*}"
    for var in $vars; do
        echo ${var#$prefix}
    done
}

hsh_size() { local hash=$1
    hsh_keys $hash | wc -l
}
