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

}

main
