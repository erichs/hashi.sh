 hashi.sh - Hierarchical Key/Value Store for Bash
===================================

## Really?

Well, no, not technically. Bash doesn't support hashes natively. So, we fake it via
obfuscated and escaped environment variables. For really simple use cases, it's almost
good enough. On the plus-side, it's in memory and relatively fast.

## Why would I use this?

You probably wouldn't. I use it to load snippets of text into the shell for frequent and
fast programmatic access. 

Potential uses: 

* hardware catalog
* phone directory
* lightweight key 'registry'
* dictionary/map/lookup table
* implement a simple cache mechanism
* store a histogram of frequently seen files/directories/processes
* retrieve a count or list of unique keys stored
* etc...

## Why Hierarchical?

So we can store keys in related groupings.  Since we're storing into ENV variables, this creates
a sort of 'namespace'.  Hashi.sh calls these namespaces 'topics'.  Topics contain buckets, which 
contain keys, which have values.

## Show me

Sure:

```bash
    $ source hashi.sh
    $ hsh_store hosts machine1 fqdn machine1.somewhere.net
    $ hsh_store hosts machine1 hw "Dell Poweredge 1950"
    $ hsh_store hosts machine1 user billybob

    $ echo "FQDN: $(hsh_get hosts machine1 fqdn)"
```
This software is released into the public domain.  Please use it responsibly.

Enjoy.

> If a man wishes to rid himself of a feeling of unbearable oppression, he may have to take hashish. -- Friedrich Nietzsche