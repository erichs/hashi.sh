#!/bin/bash
# hashi.sh - ultra-simple key/value hash

#### API: use these primitives in your script
# See apidoc.md for full documentation

hsh() { local op=${1:-}
    if [ -z "$op" ]; then
        __usage
        return 1
    fi
    for method in $(__hsh_dsl_methods); do
        if [ "hsh_$op" == $method ]; then
            shift
            $method "${1:-}" "${2:-}" "${3:-}"
            return $?
        fi
    done
    __usage
    return 1
}

hsh_set() { local hash=${1:-} key=${2:-} value=${3:-}
    optional_doc <<-'end' && return 0
	### set

	Sets a hash key/value pair.

	Required parameters: hash, key, and value

	```bash
	# assign value 'apple' to key 'favorite' in hash 'fruits'
	$ hsh set fruits favorite apple
	```
	end
    __check_args hash key value || return 1
    local fullkey=$(__generate_key "$hash" "$key")
    eval "$fullkey='${value}'" || return 1
    return 0
}

hsh_get() { local hash=${1:-} key=${2:-}
    optional_doc <<-'end' && return 0
	### get

	Gets a hash value for a given key.

	Required parameters: hash and key

	```bash
	# retrieve value of key 'favorite' from hash 'fruits'
	$ fave=$(hsh get fruits favorite)
	$ echo $fave
	apple
	$
	```
	end
    __check_args hash key || return 1
    local fullkey=$(__generate_key "$hash" "$key")
    local val=${!fullkey:-}  # the {foo:-} idiom is safe to use with set -o nounset, aka set -u
    if [ -n "$val" ]; then
        echo "$val"
        return 0
    else
        return 1
    fi
}

hsh_keys() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### keys

	Displays all keys for a given hash, sorted, one per line.

	Required parameters: hash

	```bash
	# assume hash 'fruits' contains:
	# 'favorite' => 'apple', 'most_colorful' => 'orange', 'least_favorite' => 'kiwi'
	$ hsh keys fruits
	favorite
	least_favorite
	most_colorful
	$
	```
	end
    __check_args hash || return 1
    local key vars
    __eval_assign_hashvars "$hash" vars
    for var in $vars; do
        key=$(__get_key_from_var $var)
        echo "$(__unescape_key $key)"
    done
}

hsh_size() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### size

	Displays number of key/value pairs in hash.

	Required parameters: hash

	```bash
	# assume hash 'cars' contains:
	# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
	$ hsh size cars
	2
	$
	```
	end
    __check_args hash || return 1

    local var vars size=0
    __eval_assign_hashvars "$hash" vars
    for var in $vars; do size=$((size + 1)); done
    echo $size
}

hsh_clear() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### clear

	Deletes a hash.

	Required parameters: hash

	```bash
	# assume hash 'cars' contains:
	# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
	$ hsh clear cars
	$ hsh size cars
	0
	$
	```
	end
    __check_args hash || return 1
    __unset_hash "$hash"
}

hsh_del() { local hash=${1:-} key=${2:-}
    optional_doc <<-'end' && return 0
	### del

	Deletes a key from a hash.

	Required parameters: hash key

	```bash
	# assume hash 'cars' contains:
	# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
	$ hsh del cars slowest
	$ hsh keys cars
	fastest
	$
	```
	end
    __check_args hash key || return 1
    __unset_key "$hash" "$key"
}

hsh_each() { local hash=${1:-} code=${2:-}
    optional_doc <<-'end' && return 0
	### each

	Iterates over key/value pairs in hash, evaluating code.
	At each iteration, 'each' sets the variables 'key' and 'value',
	which may be referenced in your code as '$key' and '$value'.

	For clarity and ease-of-use, it may be necessary to put your code
	into a separate function that is called at each iteration.

	Required parameters: hash, and code (evaluated string or function name)

	```bash
	# assume hash 'books' contains:
	# longest => 'War and Peace', latest => 'Drive'
	$ hsh each books 'echo The $key book I have read is $value.'
	The latest book I have read is Drive.
	The longest book I have read is War and Peace.
	$
	```
	end
    __check_args hash code || return 1
    for key in $(hsh_keys "$hash"); do
        value=$(hsh_get "$hash" "$key")
        eval "$code"
    done
}

hsh_values() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### values

	Displays all values stored in hash.

	Required parameters: hash

	```bash
	# assume hash 'books' contains:
	# longest => 'War and Peace', latest => 'Drive'
	$ hsh values books
	Drive
	War and Peace
	$
	```
	end
    __check_args hash || return 1
    hsh_each "$hash" 'echo $value'
}

hsh_getall() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### getall

	Displays each key/value pair in hash.

	Required parameters: hash

	```bash
	# assume hash 'cars' contains:
	# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
	$ hsh getall cars
	fastest: Bugatti Veyron
	slowest: Smart Coupe
	$
	```
	end
    __check_args hash || return 1
    hsh_each $hash 'echo $key: $value'
}

hsh_haskey() { local hash=${1:-} key=${2:-}
    optional_doc <<-'end' && return 0
	### haskey

	does hash contain key?

	returns 0 (success) if hash contains key.

	returns 1 (failure) if hash does not.

	Required parameters: hash

	```bash
	# assume hash 'shells' contains:
	# 1 => ksh, 2 => zsh, 3 => bash, 4 = > sh
	$ if hsh haskey shells csh; then echo 'csh is supported'; else echo 'csh is unsupported'; fi
	csh is unsupported
	$
	```
	end
    __check_args hash key || return 1
    return $(hsh_get $hash $key >/dev/null)
}

hsh_isempty() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### isempty

	is hash empty of all key/value pairs?

	returns 0 (success) if hash is empty.

	returns 1 (failure) if hash is not.

	Required parameters: hash

	```bash
	# assume hash 'foo' contains:
	# one => 1
	$ hsh del foo one
	$ if hsh isempty foo; then echo 'hash foo is empty'; fi
	hash foo is empty

	# also, for an uninitialized hash:
	$ if hsh isempty bar; then echo 'hash bar is empty'; fi
	hash bar is empty
	$
	```
	end
    __check_args hash || return 1
    [ $(hsh_size $hash) != 0 ] && return 1
    return 0
}

hsh_declare() { local hash=${1:-}
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
    __check_args hash || return 1
    eval "$hash() { op=\${1:-}; shift; hsh \$op $hash \$*; }"
}

hsh_undeclare() { local hash=${1:-}
    optional_doc <<-'end' && return 0
	### hsh_undeclare

	Remove the wrapper function around 'hsh()'. NOTE: this does not remove the hash referenced by 'declare'. To remove a hash you must use 'clear'.

	Required parameters: hash

	```bash
	$ hsh_declare dogs
	$ dogs set breed Collie
	$ dogs get breed
	Collie
	$ hsh_undeclare dogs  # remove the convenience method named 'dogs'
	dogs
	dogs: command not found
	$ hsh clear dogs  # fully remove the hash
	```
	end
    __check_args hash || return 1
    unset -f $hash
}

hsh_list() {
    optional_doc <<-'end' && return 0
	### hsh_list

	Display a sorted list of all hashes defined using hashi.sh

	Required parameters: none

	```bash
	$ hsh set dogs breed Collie
	$ hsh set cats breed Siamese
	$ hsh_list
	cats
	dogs
	$
	```
	end
    local prefix="__${_delim}_"
    local allkeys=$(eval "echo \${!$prefix*}")
    (
      trim_hash_from_key() {
        local prehsh posthsh
        eval "prehsh=\${item%_${_delim}_*}"  # 'item' is set in eachitem iterator
        eval "posthsh=\${prehsh#*${_delim}_}"
        echo "$(__unescape_key $posthsh)"
      }

      __eachitem_in_string "$allkeys" trim_hash_from_key | sort -u
    )
}

#### internal helper methods & vars

_delim=qXzJj

__generate_key() { local hash=${1:-} key=${2:-}
    local str="__${_delim}_${hash}_${_delim}_${key}"  # separate hashes and keys with unlikely yet searchable string.
    local esc=${str//-/___}                           # bash doesn't allow hyphens in variable names. bummer.
    echo ${esc// /JxXzQ}                              # also, escape spaces with a statistically unlikely string.
}

__unescape_key() { local key=$1
    local esc=${key//___/-}
    echo ${esc//JxXzQ/ }
}

__unset_hash() { local hash=${1:-}
    $(hsh_isempty "$hash")  && return 1    # unsetting empty hash is error

    for key in $(hsh_keys "$hash"); do
        __unset_key "$hash" "$key"
    done

    ! $(hsh_isempty "$hash") && return 1
    return 0
}

__unset_key() { local hash=${1:-} key=${2:-}
    local fullkey=$(__generate_key "$hash" "$key")
    unset -v $fullkey
    hsh_haskey "$hash" "$key" && return 1
    return 0
}

__check_args() { local arg=${1:-}
    until [ -z "${arg:-}" ]; do
        if [ -z "${!arg}" ]; then
            echo "must provide $arg with this operation!"
            return 1
        fi
        shift
        arg=${1:-}
    done
    return 0
}

optional_doc() {
    if [ "${__display_documentation:-}" == 1 ]; then
        cat -
        return 0
    else
        return 1
    fi
}

__all_hsh_methods() {
    # return list of all defined functions, beginning with 'hsh_'
    compgen -A function hsh_
}

__not_for_dsl_methods() {
    echo 'hsh_declare'
    echo 'hsh_undeclare'
    echo 'hsh_list'
}

__hsh_dsl_methods() {
    local method excluded
    (   # define helper function with 'private' scope
        is_excluded() { local method=$1
        local excluded
            for excluded in $(__not_for_dsl_methods); do
                if [ $method == $excluded ]; then
                    return 0
                fi
            done
            return 1
        }

        for method in $(__all_hsh_methods); do
            if ! is_excluded $method; then
                echo $method
            fi
        done
    )
}

__generate_apidoc() {
    __display_documentation=1
    for method in $(__all_hsh_methods); do eval $method; echo ; echo ;  done > apidoc.md
    unset __display_documentation
}

__usage() {
    echo "Usage: $(__outermost_function) op hashname [key] [value]"
    echo "   where op is one of:"
    local prefix="hsh_"
    for method in $(__hsh_dsl_methods); do
        echo "   ${method#$prefix}"  # auto-generate op list
    done
}

__outermost_function() {
    # returns name of 'outermost' function: last element of FUNCNAME[].
    local funclist=${FUNCNAME[@]}    # space-delimited list of function callers, arbitrary depth
    echo ${funclist##* }             # eat everything up through the last space
}

__get_hash_prefix() { local hash=$1
    echo $(__generate_key "$hash")
}

__eval_assign_hashvars() { local hash=$1 var=$2
    local prefix=$(__get_hash_prefix "$hash")
    eval $var="\${!$prefix*}"
}

__get_key_from_var() { local var=$1
    echo ${var##*${_delim}_}
}

__eachitem_in_string() { local string=$1 code=$2
    OIFS=$IFS
    IFS=' '
    for item in $string; do
        eval "$code"
    done
    IFS=$OIFS
}
__eachitem_in_list() { local list=$1 code=$2
    OIFS=$IFS
    IFS='
'
    for item in $list; do
        eval $code
    done
    IFS=$OIFS
}
