#!/bin/bash

set -e
source init.inc

REV=$1
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    echo "running tests for hashi.sh..."

    label "hsh_store accepts alpha"
    hsh_store topic bucket key val
    [ "$?" == "0" ] || flunk "Didn't store alpha!"
    pass

    label "hsh_store accepts numeric"
    hsh_store 1 2 3 4
    [ "$?" == "0" ] || flunk "Didn't store numeric!"
    pass

    label "hsh_store accepts alphanum with hypens"
    hsh_store topic-1 bucket-2 key-3 value-4
    [ "$?" == "0" ] || flunk "Didn't store numeric!"
    pass

    label "hsh_store accepts long value"
    hsh_store ltopic lbucket lkey "long value here"
    [ "$?" == "0" ] || flunk "Didn't store long value!"
    pass

    local val
    label "hsh_get retrieves alpha"
    val=$(hsh_get topic bucket key)
    [ "$val" == "val" ] || flunk "Didn't get alpha!"
    pass

    label "hsh_get retrieves numeric"
    val=$(hsh_get 1 2 3)
    [ "$val" == "4" ] || flunk "Didn't get numeric!"
    pass

    label "hsh_get retrieves alphanum with hypens"
    val=$(hsh_get topic-1 bucket-2 key-3)
    [ "$val" == "value-4" ] || flunk "Didn't get alphanum with hypens!"
    pass

    label "hsh_get retrieves long value"
    val=$(hsh_get ltopic lbucket lkey)
    [ "$val" == "long value here" ] || flunk "Didn't get long value!"
    pass

    label "hsh_get fails to retrieves unknown key"
    val=$(hsh_get some unknown key)
    [ "$val" == "" ] || flunk "Expected NULL, got: $val"
    pass

    cleanup
}

main
