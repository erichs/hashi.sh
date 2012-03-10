#!/bin/bash

hsh() { local op=${1:-}
    if [ -z "$op" ]; then
        __usage
        return 1
    fi
    for method in $(__methods); do
        if [ "hsh_$op" == $method ]; then
            shift
            $method $*
            return $?
        fi
    done
    __usage
    return 1
}

__usage() {
    echo "Usage: $(__outermost_function) op hashname [key] [value]"
    echo "   where op is one of:"
    local prefix="hsh_"
    for method in $(__methods); do
        echo "   ${method#$prefix}"  # auto-generate op list
    done
}

__outermost_function() {
    # returns name of 'outermost' function: last element of FUNCNAME[].
    local funclist=${FUNCNAME[@]}    # space-delimited list of function callers, arbitrary depth
    echo ${funclist##* }             # eat everything up through the last space
}

hsh_declare() { local hash=$1
    optional_doc <<-'end' && return 0
	### hsh_declare

	Declare a wrapper function around 'hsh()'. This allows you to eliminate one argument
	from all subsequent api calls for that hash.

	Required parameters: hash

	```bash
	$ hsh_declare dogs
	$ dogs set breed Collie
	$ dogs get breed
	Collie
	$
	```
	end
    __check_args hash
    echo "hash is: $hash"
    eval "$hash() { op=\$1; shift; hsh \$op $hash \$*; }"
}
