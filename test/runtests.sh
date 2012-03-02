#!/bin/bash

set -e
source ./init.inc

start_clock

for test in $(ls test-*.sh);
do
    ./$test $1
done

echo "All tests complete."
stop_clock

exit 0
