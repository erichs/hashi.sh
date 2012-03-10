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

    label sets key with spaces
    assert hsh_set hash '"key with spaces"' value

    label sets other key with spaces
    assert hsh_set hash '"key with other spaces"' other_value

    label gets key with spaces
    local key='key with spaces'
    local testval=$(hsh_get hash "$key")
    assert [ "$testval" == value ]

    label sets hash with spaces
    assert hsh_set '"hash with spaces"' key val

    label gets hash with spaces
    local hwsp='hash with spaces'
    testval=$(hsh_get "$hwsp" key)
    assert [ "$testval" == val ]

}

main
