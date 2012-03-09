### hsh_del

Deletes a key from a hash.

Required parameters: hash key

```bash
# assume hash 'cars' contains:
# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
$ hsh_del cars slowest
$ hsh_keys cars
fastest
$
```


### hsh_each

Iterates over key/value pairs in hash, evaluating code.
At each iteration, hsh_each sets the variables 'key' and 'value',
which may be referenced in your code as '$key' and '$value'.

For clarity and ease-of-use, it may be necessary to put your code
into a separate function that is called at each iteration.

Required parameters: hash, and code (evaluated string or function name)

```bash
# assume hash 'books' contains:
# longest => 'War and Peace', latest => 'Drive'
$ hsh_each books 'echo The $key book I have read is $value.'
The latest book I have read is Drive.
The longest book I have read is War and Peace.
$
```


### hsh_empty

is hash empty of all key/value pairs?

returns 0 (success) if hash is empty.

returns 1 (failure) if hash is not.

```bash
# assume hash 'foo' contains:
# one => 1
$ hsh_del foo one
$ if hsh_empty foo; then echo 'hash foo is empty'; fi
hash foo is empty

# also, for an uninitialized hash:
$ if hsh_empty bar; then echo 'hash bar is empty'; fi
hash bar is empty
$
```


### hsh_get

Gets a hash value for a given key.

Required parameters: hash and key

```bash
# retrieve value of key 'favorite' from hash 'fruits'
$ fave=$(hsh_get fruits favorite)
$ echo $fave  # apple
```


### hsh_getall

Displays each key/value pair in hash.

Required parameters: hash

```bash
# assume hash 'cars' contains:
# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
$ hsh_getall cars
fastest: Bugatti Veyron
slowest: Smart Coupe
$
```


### hsh_has

does hash contain key?

returns 0 (success) if hash contains key.

returns 1 (failure) if hash does not.

```bash
# assume hash 'shells' contains:
# 1 => ksh, 2 => zsh, 3 => bash, 4 = > sh
$ if hsh_has shells csh; then echo 'csh is supported'; else echo 'csh is unsupported'; fi
csh is unsupported
$
```


### hsh_keys

Displays all keys for a given hash, sorted, one per line.

Required parameters: hash

```bash
# assume hash 'fruits' contains:
# 'favorite' => 'apple', 'most_colorful' => 'orange', 'least_favorite' => 'kiwi'
$ hsh_keys fruits
favorite
least_favorite
most_colorful
$
```


### hsh_set

Sets a hash key/value pair.

Required parameters: hash, key, and value

```bash
# assign value 'apple' to key 'favorite' in hash 'fruits'
$ hsh_set fruits favorite apple
```


### hsh_size

Displays number of key/value pairs in hash.

Required parameters: hash

```bash
# assume hash 'cars' contains:
# fastest => 'Bugatti Veyron', slowest => 'Smart Coupe'
$ hsh_size cars
2
$
```


### hsh_values

Displays all values stored in hash.

Required parameters: hash

```bash
# assume hash 'books' contains:
# longest => 'War and Peace', latest => 'Drive'
$ hsh_values books
Drive
War and Peace
$
```


