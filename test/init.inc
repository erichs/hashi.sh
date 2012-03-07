#!/bin/bash

# Bash unit test helper functions and setup, intended
# to be sourced from scripts in the /test dir

set -e

START_TIME=0
END_TIME=0

GREEN="\033[0;32m"
  RED="\033[0;31m"
RESET="\033[0;37;00m"

assert() {
    if eval "$*"; then
        pass
    else
        flunk $label: asserted $*
    fi
}

fixture() {
    # this sets up a test fixture, exporting the latest revision of
    # the parent git repo, and using that to test against

    local REV=$(git rev-parse --short HEAD)  # default to HEAD when no revision argument is specified
    if [ $# -gt 0 ]; then
        REV=$1
    fi
    discreet_echo "Setting up fixture repo for revision $REV...\n"

    if [ -x test_repo ]; then
        rm -rf test_repo
    fi


    mkdir test_repo
    cd test_repo  >/dev/null

    git init --quiet
    (
        cd ..
        git fast-export $REV | gzip > test_repo.gz
    )
        cat ../test_repo.gz | gunzip | git fast-import --quiet
        git checkout --quiet $REV
        rm ../test_repo.gz
}

flunk() {
    echo -e "${RED}$(basename $0) FAIL: $*${RESET}"
    exit 1
}

discreet_echo() { local loudstr=$1 softstr=${2:-}
    if [ -n "${VERBOSE:-}" ]; then
        echo -en "$loudstr"
    else
        echo -en "$softstr"
    fi
}

label() {
   label=$*
   if [ -z "${testnum:-}" ]; then
       testnum=0
   fi
   testnum=$((testnum + 1))
   discreet_echo "${testnum}. $label... "
}

pass() {
    discreet_echo "${GREEN}OK!${RESET}\n" "${GREEN}.${RESET}"
}

setup() {
    start_clock
    REV=${1:-}
    fixture $REV  # load Git revision in test repository
}

start_clock() {
    START_TIME=$(date +%s)
}

stop_clock() {
    local END_TIME=$(date +%s)
    local total=$((END_TIME - START_TIME))
    discreet_echo "\nRunning $(basename $0) took: $total secs.\n" "  ${total}s\n"
}

teardown() {
    local RC=$?
    unset testnum
    cd ..
    rm -rf test_repo.gz 2>/dev/null
    rm -rf test_repo 2>/dev/null
    stop_clock
    if [ $RC -ne 0 ]; then
        flunk "One or more tests did not pass!"
    fi
}

greplines() { local grepstr=${1:-}
    echo $(grep "$grepstr" | wc -l)
}
