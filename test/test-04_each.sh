#!/bin/bash

set -e
set -u

source init.inc

trap teardown EXIT # guarantee fixture teardown

REV=${1:-}
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    discreet_echo 'EACH METHOD...'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label each iterates over all keys
    assert [ $(hsh_each hash foozler | wc -l) == 3 ]

    label each does not iterate over keys outside hash
    hsh_set h2 h2key h2val
    assert [ -z "'$(hsh_each hash has_h2key)'" ]

    label each does contain sentinel key
    assert [ -n "'$(hsh_each h2 has_h2key)'" ]

}

foozler() {
    echo 'foo'
}

sentinel() { local watch_str=$1
    if [ "$watch_str" == "$key" ]; then
        echo "found $watch_str!"
    fi
}

has_h2key() {
    sentinel h2key
}

main
