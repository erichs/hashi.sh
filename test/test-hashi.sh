#!/bin/bash

set -e
source init.inc

REV=$1
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    echo 'running tests for hashi.sh...'

    label 'hsh_store accepts alpha'
    hsh_store topic bucket key val
    assert [ $? == 0 ] || flunk 'Failed to store alpha!'

    label 'hsh_store accepts numeric'
    hsh_store 1 2 3 4
    assert [ $? == 0 ] || flunk 'Failed to store numeric!'

    label 'hsh_store accepts alphanum with hypens'
    hsh_store topic-1 bucket-2 key-3 value-4
    assert [ $? == 0 ] || flunk 'Failed to store numeric!'

    label 'hsh_store accepts long value'
    hsh_store ltopic lbucket lkey 'long value here'
    assert [ $? == 0 ] || flunk 'Failed to store long value!'

    local val
    label 'hsh_get retrieves alpha'
    val=$(hsh_get topic bucket key)
    assert [ $val == val ] || flunk 'Failed to get alpha!'

    label 'hsh_get retrieves numeric'
    val=$(hsh_get 1 2 3)
    assert [ $val == 4 ] || flunk 'Failed to get numeric!'

    label 'hsh_get retrieves alphanum with hypens'
    val=$(hsh_get topic-1 bucket-2 key-3)
    assert [ $val == value-4 ] || flunk 'Failed to get alphanum with hypens!'

    label 'hsh_get retrieves long value'
    val=$(hsh_get ltopic lbucket lkey)
    assert [ \'$val\' == \'long value here\' ] || flunk 'Failed to get long value!'

    label 'hsh_get fails to retrieve unknown key'
    val=$(hsh_get some unknown key)
    assert [ \'$val\' == \'\' ] || flunk 'Expected NULL, got: $val'

    teardown
}

main
