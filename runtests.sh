#!/bin/bash

source ./test/init.inc

while getopts v arg
do
    case $arg in
        v)    export VERBOSE=1
              shift;;
        ?)    echo "Usage: $(basename $0) [-v] [git rev]"
              exit 1;;
    esac
done


set -e
set -u

(
    cd test

    start_clock

    rc=0
    for test in $(ls test-*.sh);
    do
        [ $rc != 0 ] && continue
        (
        ./$test ${1:-}
        )
        rc=$?
    done

    discreet_echo "" "total runtime: "
    stop_clock
    if [ $rc == 0 ]; then
        discreet_echo "${GREEN}All tests complete.${RESET}\n" "${GREEN}OK!${RESET}\n"
    fi
)

exit 0
