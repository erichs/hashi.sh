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

    echo 'RM METHOD...'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label rm removes key
    hsh_rm hash key2
    assert [ -z "$(hsh_get hash key2)" ]

    label rm decrements size
    assert [ $(hsh_size hash) == 2 ]

    label keys does not display removed key
    assert [ -z "$(hsh_keys hash | grep key2)" ]

    label rm removes hash
    hsh_rm hash
    assert [ $(hsh_size hash) == 0 ]
}

main
