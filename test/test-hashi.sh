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
    assert hsh_set hash lkey \'long value here\'
    label gets long value
    assert [ \'$(hsh_get hash lkey)\' == \'long value here\' ]  # '

    label fails to retrieve unknown key
    assert [ \'$(hsh_get hash unknown key)\' == \'\' ] # '

    label get hash keys
    assert [ ! -z \'$(hsh_keys hash)\' ] # '

    label valid keys length
    assert [ $(hsh_keys hash | wc -l) == 4 ]

    label get hash size
    assert [ $(hsh_size hash) == 4 ]

    label undef size is zero
    assert [ $(hsh_size undefined) == 0 ]

    label hsh_keys handles hyphens
    hsh_set tst key1 val1
    hsh_set tst-h key1 val1
    tst_size=$(hsh_keys tst | wc -l)
    tsth_size=$(hsh_keys tst-h | wc -l)

    assert [ $tst_size == $tsth_size ]

}

main
