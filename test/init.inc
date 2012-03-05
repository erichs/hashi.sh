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
        flunk asserted $*
    fi
}

fixture() {
    # this sets up a test fixture, exporting the latest revision of
    # the parent git repo, and using that to test against

    local REV=$(git rev-parse --short HEAD)  # default to HEAD when no revision argument is specified
    if [ ! -z "$1" ]; then
        REV=$1
    fi
    echo "Setting up fixture repo for revision $REV..."

    if [ -x test_repo ]; then
        rm -rf test_repo
    fi


    mkdir test_repo
    cd test_repo

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
    echo -e "${RED}FAIL: $*${RESET}"
    exit 1
}

label() {
    if [ -f .testnum ]; then
        TESTNUM=`cat .testnum`
    else
        TESTNUM=0
    fi
    TESTNUM=$((TESTNUM+1))
    echo -n "$TESTNUM. $*... "
    echo $TESTNUM > .testnum
}

pass() {
    echo -e "${GREEN}OK!${RESET}"
}

setup() {
    start_clock
    REV=$1
    fixture $REV  # load Git revision in test repository
}

start_clock() {
    START_TIME=$(date +%s)
}

stop_clock() {
    END_TIME=$(date +%s)
    echo "Testing took: $((END_TIME - START_TIME)) secs."
}

teardown() {
    cd ..
    rm -rf test_repo 2>/dev/null
    stop_clock
}
