#!/bin/bash
# hashi.sh - ultra-simple hierarchical key/value hash
#   topics set the 'namespace' for hash-buckets
#   buckets contain key/value pairs

set -e

hsh_store()
{
    local topic=$1 bucket=$2 key=$3 val=$4
    local fullkey=$(hsh_escape_key "__${topic}_${bucket}_${key}")
    eval "$fullkey='$val'"
}

hsh_get()
{
    hsh_save_options && set +u
    local topic=$1 bucket=$2 key=$3
    local fullkey=$(hsh_escape_key "__${topic}_${bucket}_${key}")
    echo ${!fullkey}
    hsh_restore_options
}

hsh_escape_key() {  # bash doesn't allow hypens in variable names. bummer.
    local key=$1
    echo ${key//-/___}
}

hsh_save_options() {
    HSH_SETOPTIONS=$(set +o)
}

hsh_restore_options() {
    # leading space in command disables bash history
    while read opt; do eval " $opt"; done < <(echo "$HSH_SETOPTIONS")
}

HSH_SETOPTIONS=""
