#!/bin/bash
# hashi.sh - ultra-simple key/value hash

set -e

#### API: use these primitives in your script

hsh_set() { local hash=$1 key=$2 val=$3
    local fullkey=$(hsh_generate_key $hash $key)
    eval "$fullkey='$val'"
}

hsh_get() { local hash=$1 key=$2
    local fullkey=$(hsh_generate_key $hash $key)
    echo ${!fullkey:-}  # the {foo:-} idiom is safe to use with set -o nounset, aka set -u
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
}

hsh_unset_key() { local hash=$1 key=$2
    local fullkey=$(hsh_generate_key $hash $key)
    unset -v $fullkey
}

