#!/bin/bash

# Bash unit test helper functions and setup, intended
# to be sourced from scripts in the /test dir

set -e

START_TIME=0
END_TIME=0

GREEN="\033[0;32m"
  RED="\033[0;31m"
RESET="\033[0;37;00m"

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

cleanup() {
    cd ..
    rm -rf test_repo 2>/dev/null
    stop_clock
}

flunk() {
    echo -e "${RED}FAIL: $*${RESET}"
    exit 1
}

pass() {
    echo -e "${GREEN}OK!${RESET}"
}

label() {
    if [ -f .testnum ]; then
        TESTNUM=`cat .testnum`
    else
        TESTNUM=0
    fi
    TESTNUM=$((TESTNUM+1))
    echo -n "$TESTNUM. $1... "
    echo $TESTNUM > .testnum
}

# this sets up a test fixture, exporting the latest revision of
# the parent git repo, and using that to test against
fixture() {
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

check_basic_documentation() {
    flags=$(grep getopts $SCRIPT | grep "while getopts" | awk '{print $3}' | grep -oP ".")

    label "short flags are documented"
    for flag in $flags
    do
        [ "$flag" == ":" ] || [ "$flag" == "-" ] && continue
        [ $(grep -- "B<-$flag>" $SCRIPT | grep -v =item | wc -l) -ge 1 ] || flunk "Perldoc Usage is missing -$flag!"
        [ $(grep -- "B<-$flag>" $SCRIPT | wc -l) -ge 2 ] || flunk "Perldoc is missing for -$flag!"
    done
    pass

    label "version matches Perldoc"
    $(version_matches_doc $SCRIPT) || flunk "Version missing or mismatch in Perldoc!"
    pass
}

check_basic_usage() {
    label "-h gives help"
    [ ! -z "$($SCRIPT -h 2>&1 | grep "Usage")" ] || flunk "Didn't get expected help with -h!"
    pass
}

version_matches_doc() {
    version=$(grep "VERSION=" $1 | awk -F'=' '{print $2}')
    dv=$(grep -- "B<v" $1 | awk -F'v' '{print $2}')
    docversion=${dv%?}
    [ "$docversion" == "$version" ];
}
