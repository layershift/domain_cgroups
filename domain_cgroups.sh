#!/bin/bash

# This will be a script that will improve cgroups top output to show usage per domain 

users="/root/operations/domain_cgroups/users.txt"
domain_cgroups="/root/operations/domain_cgroups"
current_memory="memory.usage_in_bytes"
max_memory="memory.max_usage_in_bytes"
system="/sys/fs/cgroup/memory/user.slice/user-"

if [ -f $users ]
        then
                rm -f $users
fi

if [ -d $domain_cgroups ]
        then
                rm -rf $domain_cgroups
fi
mkdir $domain_cgroups
touch $users

function get_users {
    find /sys/fs/cgroup/memory/user.slice/* -type d  > $users
    sed -i 's/\/sys\/fs\/cgroup\/memory\/user.slice\/user-//g' $users 
    sed -i 's/.slice//g' $users 
    sed -i -e "1d" $users 
}

function get_memory {
for i in `cat $users` ; do echo $i | cat $system$i.slice/$current_memory ; done
}

get_users
get_memory