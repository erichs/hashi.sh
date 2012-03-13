#!/bin/bash

# this example implements a hash that may contain other hashes as values,
# and a recursive function to retrieve those values

source ../hashi.sh

main() {

    # Let's set some roles for a fictitious company
    hsh_declare roles
    roles set butcher George
    roles set baker Edward
    roles set candlestick_maker Fred


    # Let's create a list of assistants, also
    hsh_declare assistants
    assistants set gofer Max
    assistants set coffee_maker Steve
    assistants set janitor Bob

    # Now, add the assistants hash as a key to roles
    roles set support_staff assistants

    # And, set a few keys in our company hash
    hsh_declare company
    company set name Three_Men_in_a_Tub_inc
    company set staff roles
    company set twitter_username rubadub

    # finally, pretty-print the hash:
    print_descending company
}

print_descending() { local hash=$1
    if [ -z "${level:-}" ]; then
        level=0
    else
        level=$((level + 1))  # I've recursed, so increment
    fi
    (
        # declare some 'private scope' utility functions

        level_print() { local lvl=$1 str=$2  # ensure things have proper indentation
            until [ $lvl == 0 ]; do
                echo -n "    "
                lvl=$((lvl - 1))
            done
            echo $str
        }

        is_a_hash() { local hash=$1
            [ $(hsh size "$hash") -gt 0 ] # non-existent hashes have size 0...
        }

        print_kv() {
            if is_a_hash "$value"; then
                level_print $level "$key:"
                print_descending "$value"  # recurse
            else
                level_print $level "$key: $value"
            fi
        }

        # iterate over each key/value pair, calling our recursive print function
        hsh each $hash print_kv
    )
    level=$((level - 1))  # decrement before returning
}

main
