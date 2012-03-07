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

    echo 'DEL METHOD...'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label del removes key
    hsh_del hash key2
    assert [ -z "$(hsh_get hash key2)" ]

    label del decrements size
    assert [ $(hsh_size hash) == 2 ]

    label keys does not display removed key
    assert [ -z "$(hsh_keys hash | grep key2)" ]

    label del removes hash
    hsh_del hash
    assert [ $(hsh_size hash) == 0 ]
}

main
