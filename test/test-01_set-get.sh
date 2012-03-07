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

    discreet_echo 'GET and SET methods...\n'

    label sets alpha
    assert hsh_set hash key val
    label gets alpha
    assert [ $(hsh_get hash key) == val ]

    label sets numeric
    assert hsh_set hash 2 3
    label gets numeric
    assert [ $(hsh_get hash 2) == 3 ]

    label sets hyphen-hash
    assert hsh_set hyphen-hash key val
    label gets hyphen-hash
    assert [ $(hsh_get hyphen-hash key) == val ]

    label sets alphanum with hypens
    assert hsh_set hash-1 key-2 value-2
    label gets alphanum with hypens
    assert [ $(hsh_get hash-1 key-2) == value-2 ]

    label sets long value
    assert hsh_set hash lkey '"long value here"'
    label gets long value
    assert [ '"$(hsh_get hash lkey)"' == '"long value here"' ]

    label fails to retrieve unknown key
    assert [ '"$(hsh_get hash unknown key)"' == '""' ]

}

main
