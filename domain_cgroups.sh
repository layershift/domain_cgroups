#!/bin/bash

# This will be a script that will improve cgroups top output to show usage per domain 

users_list="/root/operations/domain_cgroups/users.txt"
domain_cgroups="/root/operations/domain_cgroups"
current_memory="memory.usage_in_bytes"
max_memory="memory.max_usage_in_bytes"
system="/sys/fs/cgroup/memory/user.slice/user-"
logfile="/root/operations/domain_cgroups/memory.txt"

if [ -f $users_list ]
        then
                rm -f $users_list
fi

if [ -f $logfile ]
        then
                rm -rf $logfile
fi

if [ -d $domain_cgroups ]
        then
                rm -rf $domain_cgroups
fi


 mkdir $domain_cgroups
 touch $users_list
 touch $logfile

function get_users {
        find /sys/fs/cgroup/memory/user.slice/* -type d  > $users_list
        sed -i 's/\/sys\/fs\/cgroup\/memory\/user.slice\/user-//g' $users_list 
        sed -i 's/.slice//g' $users_list 
        sed -i -e "1d" $users_list 
}

function get_memory {
        echo "User ,Domain ,Current ,MB ,Max ,MB"
        while read -r user; do
        local name=`id -un -- $user`
        local domain=`grep $user /etc/passwd | head -1 | awk -F ":" '{print $1" "$6}' | awk -F "/" '{print $5}'`
        local value_current=`cat $system$user.slice/$current_memory`
        local current=$(( $value_current/1024/1024))
        local value_max=`cat $system$user.slice/$max_memory`
        local max=$(( $value_max/1024/1024))
        echo -e "$name ,$domain ,$current ,MB ,$max ,MB" 
        done < "$users_list"
        }

######Table functions######
function printTable()
{
    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                # Add Header Or Body

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}
#####/table functions######
get_users
get_memory > $logfile
printTable ',' "$(cat $logfile)" > $logfile

echo -e "Do you want the table sorted based on highest Ram usage, or based on current Ram usage?"
echo -e "1. Current Ram Usage"
echo -e "2. Highest Ram Usage"

read filter

if [ $filter = "1" ]
    then
    cat $logfile | (sed -u 3q; sort --k 6 -n -r)
elif [ $filter = "2" ]
    then
    cat $logfile | (sed -u 3q; sort --k 10 -n -r)
fi