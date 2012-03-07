#!/bin/bash

set -e
set -u

source init.inc

trap teardown EXIT # guarantee fixture teardown

REV=${1:-}
SCRIPT='./hashi.sh'
EXTENSION='./extras/hsh-dsl.sh'

main() {
    setup $REV
    source $SCRIPT
    source $EXTENSION

    discreet_echo 'DSL EXTENSION...\n'

    label hsh is implemented
    hsh >/dev/null
    assert [ $? == 0 ]

    label hsh without parameters gives usage
    assert [ $(hsh | greplines "Usage") == 1 ]

    label hsh with one parameter gives usage
    assert [ $(hsh parm1 | greplines "Usage") == 1 ]

    label 'hsh get hash' is error
    assert [ $(hsh get hash | greplines "must provide key") == 1 ]

    label 'hsh get hash key' retrieves value
    hsh_set hash key val
    assert [ $(hsh get hash key | grep "val") == val ]

    label 'hsh set hash' is error
    assert [ $(hsh set hash | greplines "must provide key") == 1 ]

    label 'hsh set hash key' is error
    assert [ $(hsh set hash key | greplines "must provide value") == 1 ]

    label 'hsh set hash key2 val2' sets value
    hsh set hash key2 val2
    assert [ $(hsh get hash key2) == val2 ]



}

main
