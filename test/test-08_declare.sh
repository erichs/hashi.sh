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

    discreet_echo 'DECLARE AND UNDECLARE...\n'

    set +e

    label hsh_declare is implemented
    hsh_declare hshtest >/dev/null
    assert [ $? == 0 ]

    label hshtest without parameters gives usage
    assert [ $(hshtest | greplines "Usage") == 1 ]

    label hshtest with one parameter gives usage
    assert [ $(hshtest parm1 | greplines "Usage") == 1 ]

    label hshtest with unknown op gives usage
    assert [ $(hshtest unknown_op | greplines "Usage") == 1 ]

    for method in $(__hsh_dsl_methods); do
        op=${method#hsh_}
        label usage contains $op
        assert [ $(hshtest | greplines "$op") -ge 1 ]
    done

    label 'hshtest get' is error
    assert [ $(hshtest get | greplines "must provide key") == 1 ]

    label 'hshtest get boguskey' gives error code
    hshtest get boguskey >/dev/null 2>&1
    assert [ $? == 1 ]

    label 'hshtest del key1' does not return error
    hshtest set key1 val1
    hshtest del key1 >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'hshtest del' does return error
    hshtest del >/dev/null 2>&1
    assert [ $? == 1 ]

    set -e

    label 'hshtest get key' retrieves value
    hshtest set key val
    assert [ $(hshtest get key | grep "val") == val ]

    label 'hshtest set' is error
    assert [ $(hshtest set | greplines "must provide key") == 1 ]

    label 'hshtest set key' is error
    assert [ $(hshtest set key | greplines "must provide value") == 1 ]

    label 'hshtest set key2 val2' gets value
    hshtest set key2 val2
    assert [ $(hshtest get key2) == val2 ]

    label 'hshtest get boguskey' gives empty string
    assert [ $(hshtest get boguskey) == '' ]

    set +e

    label 'hshtest keys' does not return error
    hshtest keys >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'hshtest size' does not return error
    hshtest size >/dev/null 2>&1
    assert [ $? == 0 ]

    set -e

    label 'hshtest size' gives correct size
    assert [ $(hshtest size) == 2 ]

    label hsh_undeclare is implemented
    hsh_undeclare hshtest >/dev/null
    assert [ $? == 0 ]

    label hshtest is undeclared
    assert [ $(hshtest 2>&1 | greplines "command not found") == 1 ]

}

main
