#!/bin/bash

set -e
source init.inc

REV=$1
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    echo 'running tests for hashi.sh...'

    label stores alpha
    assert hsh_store topic bucket key val

    label stores numeric
    assert hsh_store 1 2 3 4

    label stores alphanum with hypens
    assert hsh_store topic-1 bucket-2 key-3 value-4

    label stores long value
    assert hsh_store ltopic lbucket lkey \'long value here\'

    label retrieves alpha
    assert [ $(hsh_get topic bucket key) == val ]

    label retrieves numeric
    assert [ $(hsh_get 1 2 3) == 4 ]

    label retrieves alphanum with hypens
    assert [ $(hsh_get topic-1 bucket-2 key-3) == value-4 ]

    label retrieves long value
    assert [ \'$(hsh_get ltopic lbucket lkey)\' == \'long value here\' ]  # NB: escape '

    label fails to retrieve unknown key
    assert [ \'$(hsh_get some unknown key)\' == \'\' ] # NB: escape '

    teardown
}

main
