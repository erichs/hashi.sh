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

    discreet_echo 'HSH Wrapper...\n'

    set +e

    label hsh is implemented
    hsh >/dev/null
    assert [ $? == 1 ]

    label hsh without parameters gives usage
    assert [ $(hsh | greplines "Usage") == 1 ]

    label hsh with one parameter gives usage
    assert [ $(hsh parm1 | greplines "Usage") == 1 ]

    label hsh with unknown op gives usage
    assert [ $(hsh unknown_op hash | greplines "Usage") == 1 ]

    for method in $(__hsh_dsl_methods); do
        op=${method#hsh_}
        label usage contains $op
        assert [ $(hsh | greplines "$op") -ge 1 ]
    done

    label 'hsh get hash' is error
    assert [ $(hsh get hash | greplines "must provide key") == 1 ]

    label 'hsh get hash boguskey' gives error code
    hsh get hash boguskey >/dev/null 2>&1
    assert [ $? == 1 ]

    label 'hsh del hash2 key' does not return error
    hsh set hash2 key1 val1
    hsh del hash2 key 1 >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'hsh del unknown-hash' does return error
    hsh del unknown-hash >/dev/null 2>&1
    assert [ $? == 1 ]

    set -e

    label 'hsh get hash key' retrieves value
    hsh_set hash key val
    assert [ $(hsh get hash key | grep "val") == val ]

    label 'hsh set hash' is error
    assert [ $(hsh set hash | greplines "must provide key") == 1 ]

    label 'hsh set hash key' is error
    assert [ $(hsh set hash key | greplines "must provide value") == 1 ]

    label 'hsh set hash key2 val2' sets value
    hsh set hash key2 val2
    assert [ $(hsh get hash key2) == val2 ]

    label 'hsh get hash boguskey' gives empty string
    assert [ $(hsh get hash boguskey) == '' ]

    set +e

    label 'hsh keys hash' does not return error
    hsh keys hash >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'hsh size hash' does not return error
    hsh size hash >/dev/null 2>&1
    assert [ $? == 0 ]

    set -e

    label 'hsh size hash' gives correct size
    assert [ $(hsh size hash) == 2 ]


}

main
