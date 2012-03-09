#!/bin/bash
# hashi.sh - ultra-simple key/value hash

#### API: use these primitives in your script
# get:    2 parameters, retrieves the value for a key
# set:    3 parameters, sets a key/value pair
# del:    1 or 2 parameters, deletes hash or hash key
# has:    2 parameters, true/false: does hash contain key?
# keys:   1 parameter, displays all hash keys
# values: 1 parameter, displays all hash values
# getall: 1 parameter, displays each key/value pair
# size:   1 parameter, numeric size of all keys
# each:   2 parameters, iterates over hash, evaluating code

hsh_set() { local hash=$1 key=$2 val=$3
    local fullkey=$(hsh_generate_key $hash $key)
    eval "$fullkey='$val'" || return 1
    return 0
}

hsh_get() { local hash=$1 key=$2
    local fullkey=$(hsh_generate_key $hash $key)
    local val=${!fullkey:-}  # the {foo:-} idiom is safe to use with set -o nounset, aka set -u
    if [ -n "$val" ]; then
        echo "$val"
        return 0
    else
        return 1
    fi
}

hsh_keys() { local hash=$1
    local prefix=$(hsh_generate_key $hash)
    local vars
    eval vars="\${!$prefix*}"
    for var in $vars; do
        echo ${var#$prefix}
    done
}

hsh_size() { local hash=$1
    local size=0
    for key in $(hsh_keys $hash); do size=$((size + 1)); done
    echo $size
}

hsh_del() { local hash=$1 key=${2:-}
    if [ -z "$key" ]; then
        hsh_unset_hash "$hash"
    else
        hsh_unset_key "$hash" "$key"
    fi
}

hsh_each() { local hash=$1 code=$2
    for key in $(hsh_keys "$hash"); do
        value=$(hsh_get "$hash" "$key")
        eval "$code"
    done
}

hsh_values() { local hash=$1
    hsh_each $hash 'echo $value'
}

hsh_getall() { local hash=$1
    hsh_each $hash 'echo $key: $value'
}

hsh_has() { local hash=$1 key=$2
    return $(hsh_get $hash $key >/dev/null)
}

#### internal helper methods

hsh_escape() { local str=$1
    echo ${str//-/___}  # bash doesn't allow hyphens in variable names. bummer.
}

hsh_generate_key() { local hash=$1 key=${2:-}
    hsh_escape "__${hash}_SNIP_${key}"
}

hsh_unset_hash() { local hash=$1
    for key in $(hsh_keys $hash); do
        hsh_unset_key $hash $key
    done
    [ $(hsh_size $hash) -gt 0 ] && return 1
    return 0
}

hsh_unset_key() { local hash=$1 key=$2
    local fullkey=$(hsh_generate_key $hash $key)
    unset -v $fullkey
    hsh_has $hash $key && return 1
    return 0
}

