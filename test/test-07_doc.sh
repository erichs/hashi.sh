#!/bin/bash

set -e
set -u

source init.inc

trap teardown EXIT # guarantee fixture teardown

REV=${1:-}
SCRIPT='./hashi.sh'

main() {
    setup $REV
    source $SCRIPT

    discreet_echo 'DOCUMENTATION...\n'

    __display_documentation=1
    local method text

    for method in $(__all_hsh_methods); do
        docsetup $method

        label ensure $method has triple-octothorpe
        assert has_triple_octothorpe $method

        label ensure $method has bash example
        assert has_bash_example $method

        label ensure $method bash example is closed
        assert example_is_closed $method

        label ensure $method has required parameters list
        assert has_param_list $method

        docteardown $method
    done
    unset __display_documentation

}

has_param_list() { local method=$1
    [ $(doclines $method 'Required parameters: ') == 1 ]
}

example_is_closed() { local method=$1
    [ $(doclines $method '```') == 2 ]
}

has_bash_example() { local method=$1
    [ $(doclines $method '```bash') == 1 ]
}

has_triple_octothorpe() { local method=$1
        local docname=${method#hsh_}
        [ $(doclines $method "### $docname") -gt 0 ] || [ $(doclines $method "### $method") -gt 0 ]
}


doclines() { local method=$1 string=$2
    doc $method | greplines "$string"
}

doc() { local method=$1
    cat /tmp/$method.txt
}

docsetup() { local method=$1
    eval $method > /tmp/$method.txt
}

docteardown() { local method=$1
        rm /tmp/$method.txt
}

main
