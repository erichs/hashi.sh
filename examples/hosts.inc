#!/bin/bash

source ../hashi.sh

initialize_hostdb() {

    host snowwhite name snowwhite
    host snowwhite location headquarters
    host snowwhite role "VMWare Host"
    host snowwhite servertype physical
    host snowwhite os linux

    host sneezy name sneezy
    host sneezy location cloud
    host sneezy role "CDN endpoint"
    host sneezy servertype virtual
    host sneezy vmhost snowwhite
    host sneezy os linux

    host sleepy name sleepy
    host sleepy location cloud
    host sleepy role "MSSQL DB Server"
    host sleepy servertype virtual
    host sleepy vmhost snowwhite
    host sleepy os windows
    host sleepy osver "2008 R2"

    host dopey name dopey
    host dopey location cloud
    host dopey role "Redis Server"
    host dopey servertype virtual
    host dopey vmhost snowwhite
    host dopey os linux

    host doc name doc
    host doc location cloud
    host doc role "WWW Server"
    host doc servertype virtual
    host doc vmhost snowwhite
    host doc os linux

    host happy name happy
    host happy location cloud
    host happy role "Product Test Server"
    host happy servertype virtual
    host happy vmhost snowwhite
    host happy os linux
    host happy osver "Centos 5.3"

    host bashful name bashful
    host bashful location cloud
    host bashful role "Middleware Server"
    host bashful servertype virtual
    host bashful vmhost snowwhite
    host bashful os linux

    host grumpy name grumpy
    host grumpy location cloud
    host grumpy role "Staging WWW Server"
    host grumpy servertype virtual
    host grumpy vmhost snowwhite
    host grumpy os linux

    host mirror name mirror
    host mirror location headquarters
    host mirror role "Nagios Monitoring"
    host mirror servertype physical
    host mirror os linux
}

host() { local name=$1 key=$2 value=$3
    hsh_set "$name" "$key" "$value"
}

initialize_hostdb
