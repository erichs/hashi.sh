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


### empty

is hash empty of all key/value pairs?

returns 0 (success) if hash is empty.

returns 1 (failure) if hash is not.

Required parameters: hash

```bash
# assume hash 'foo' contains:
# one => 1
$ hsh del foo one
$ if hsh empty foo; then echo 'hash foo is empty'; fi
hash foo is empty

# also, for an uninitialized hash:
$ if hsh empty bar; then echo 'hash bar is empty'; fi
hash bar is empty
$
```


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


### has

does hash contain key?

returns 0 (success) if hash contains key.

returns 1 (failure) if hash does not.

Required parameters: hash

```bash
# assume hash 'shells' contains:
# 1 => ksh, 2 => zsh, 3 => bash, 4 = > sh
$ if hsh has shells csh; then echo 'csh is supported'; else echo 'csh is unsupported'; fi
csh is unsupported
$
```


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


### set

Sets a hash key/value pair.

Required parameters: hash, key, and value

```bash
# assign value 'apple' to key 'favorite' in hash 'fruits'
$ hsh set fruits favorite apple
```


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


