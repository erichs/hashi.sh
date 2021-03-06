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

    discreet_echo 'VALUES and GETALL METHODS...\n'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label values is implemented
    hsh_values hash >/dev/null
    assert [ $? == 0 ]

    label values is of correct size
    assert [ $(hsh_values hash | wc -l) == $(hsh_size hash) ]

    label values contains correct string
    assert [ $(hsh_values hash | grep val1) == val1 ]

    label getall is implemented
    hsh_getall hash >/dev/null
    assert [ $? == 0 ]

    label getall is of correct size
    assert [ $(hsh_getall hash | wc -l) == $(hsh_size hash) ]

    label getall contains correct string
    assert [ \"$(hsh_getall hash | grep "key1: val1")\" == \"key1: val1\" ] #"
}

main
