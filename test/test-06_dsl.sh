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
    assert [ $(hsh | grep "Usage" | wc -l) == 1 ]

    label hsh with one parameter gives usage
    assert [ $(hsh parm1 | grep "Usage" | wc -l) == 1 ]
}

main
