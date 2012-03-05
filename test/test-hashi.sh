#!/bin/bash

set -e
source init.inc

trap teardown EXIT

REV=$1
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    echo 'running tests for hashi.sh...'

    label sets alpha
    assert hsh_set hash key val

    label sets numeric
    assert hsh_set hash 2 3

    label sets alphanum with hypens
    assert hsh_set hash key-2 value-2

    label sets long value
    assert hsh_set hash lkey \'long value here\'

    label retrieves alpha
    assert [ $(hsh_get hash key) == val ]

    label retrieves numeric
    assert [ $(hsh_get hash 2) == 3 ]

    label retrieves alphanum with hypens
    assert [ $(hsh_get hash key-2) == value-2 ]

    label retrieves long value
    assert [ \'$(hsh_get hash lkey)\' == \'long value here\' ]  # '

    label fails to retrieve unknown key
    assert [ \'$(hsh_get hash unknown key)\' == \'\' ] # '

    label get hash keys
    assert [ ! -z \'$(hsh_keys hash)\' ] # '

    label valid keys length
    assert [ $(hsh_keys hash | wc -l) == 4 ]

    label get hash size
    assert hsh_size hash

    teardown
}

main
