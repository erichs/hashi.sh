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
    echo ${!fullkey:-}  # the {foo:-} idiom is safe to use with set -o nounset | set -u
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
    echo $(hsh_keys $hash | wc -l)
}

hsh_rm() { local hash=$1 key=${2:-}
    if [ -z "$key" ]; then
        echo "NOT IMPLEMENTED YET"
        exit 1
    else
        hsh_unset_key "$hash" "$key"
    fi
}

#### internal helper methods

hsh_unset_key() { local hash=$1 key=$2
    local fullkey=$(hsh_generate_key $hash $key)
    unset -v $fullkey
}

hsh_generate_key() { local hash=$1 key=${2:-}
    hsh_escape "__${hash}_SNIP_${key}"
}

hsh_escape() { local str=$1
    echo ${str//-/___}  # bash doesn't allow hyphens in variable names. bummer.
}

