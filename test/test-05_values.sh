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

    echo 'VALUES METHOD...'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label values is implemented
    hsh_values hash >/dev/null
    assert [ $? == 0 ]

    label values is of correct size
    assert [ $(hsh_values hash | wc -l) == $(hsh_size hash) ]
}

main
