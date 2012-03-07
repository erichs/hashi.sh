#!/bin/bash

hsh() { local parm=${1:-}
    if [ -z "$parm" ]; then
        echo "Usage: hsh some usage here"
    fi
}
