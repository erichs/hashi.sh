#!/bin/bash

set -e
set -u

(
    cd test
    source ./init.inc

    start_clock

    for test in $(ls test-*.sh);
    do
        ./$test ${1:-}
    done

    stop_clock
    echo -e "${GREEN}All tests complete.${RESET}"
)

exit 0
