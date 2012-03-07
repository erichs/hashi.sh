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

    discreet_echo 'KEYS and SIZE methods...'

    hsh_set hash key1 val1
    hsh_set hash key2 val3
    hsh_set hash key3 val3

    label get hash keys
    assert [ ! -z '"$(hsh_keys hash)"' ]

    label valid keys length
    assert [ $(hsh_keys hash | wc -l) == 3 ]

    label valid keys content
    assert [ $(hsh_keys hash | grep key2) == key2 ]

    label get hash size
    assert [ $(hsh_size hash) == 3 ]

    label undef size is zero
    assert [ $(hsh_size undefined) == 0 ]

    label hsh_keys handles hyphens
    hsh_set tst key1 val1
    hsh_set tst-h key1 val1
    assert [ $(hsh_keys tst | wc -l) == $(hsh_keys tst-h | wc -l) ]

    label hsh_size handles hyphens
    hsh_set tst2 key1 val1
    hsh_set tst2-h key1 val1
    assert [ $(hsh_size tst2) == $(hsh_size tst2-h) ]

}

main
