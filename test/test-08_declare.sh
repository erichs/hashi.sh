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

    discreet_echo 'test Wrapper...\n'

    set +e

    label hsh_declare is implemented
    hsh_declare test >/dev/null
    assert [ $? == 0 ]

    label test without parameters gives usage
    assert [ $(test | greplines "Usage") == 1 ]

    label test with one parameter gives usage
    assert [ $(test parm1 | greplines "Usage") == 1 ]

    label test with unknown op gives usage
    assert [ $(test unknown_op | greplines "Usage") == 1 ]

    for method in $(__hsh_dsl_methods); do
        op=${method#hsh_}
        label usage contains $op
        assert [ $(test | greplines "$op") -ge 1 ]
    done

    label 'test get' is error
    assert [ $(test get | greplines "must provide key") == 1 ]

    label 'test get boguskey' gives error code
    test get boguskey >/dev/null 2>&1
    assert [ $? == 1 ]

    label 'test del key1' does not return error
    test set key1 val1
    test del key1 >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'test del' does return error
    test del >/dev/null 2>&1
    assert [ $? == 1 ]

    set -e

    label 'test get key' retrieves value
    test set key val
    assert [ $(test get key | grep "val") == val ]

    label 'test set' is error
    assert [ $(test set | greplines "must provide key") == 1 ]

    label 'test set key' is error
    assert [ $(test set key | greplines "must provide value") == 1 ]

    label 'test set key2 val2' gets value
    test set key2 val2
    assert [ $(test get key2) == val2 ]

    label 'test get boguskey' gives empty string
    assert [ $(test get boguskey) == '' ]

    set +e

    label 'test keys' does not return error
    test keys >/dev/null 2>&1
    assert [ $? == 0 ]

    label 'test size' does not return error
    test size >/dev/null 2>&1
    assert [ $? == 0 ]

    set -e

    label 'test size' gives correct size
    assert [ $(test size) == 2 ]

}

main
