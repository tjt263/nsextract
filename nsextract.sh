#!/usr/bin/env bash

####DOMAIN NAME FUNCTIONS###################################

extract_domain_names ()
{
    lynx -dump -listonly -nonumbers "$1" |
    awk -F '/+' 'NF > 1 {print $2}' |
    sort -u
}

create_domain_array ()
{
    while read -r line;
    do
        domain_names+=("$line");
    done < <(extract_domain_names "$1")
}
create_domain_array "$@"

output_domain_names ()
{
    printf '%s\n' "${domain_names[@]}"
}

####IP ADDRESS FUNCTIONS####################################

extract_ip_addresses ()
{
    for resolve in "${domain_names[@]}";
    do 
        host "$resolve" |
        awk '{print $NF}';
    done
}

create_ip_array ()
{
    while read -r line2;
    do
        ip_addresses+=("$line2");
    done < <(extract_ip_addresses)
}
create_ip_array

output_ip_addresses ()
{
    printf '%s\n' "${ip_addresses[@]}"
}

####AUXILIARY FUNCTIONS#####################################

help_usage ()
{
    printf '%s\n' 'help/usage. to be continued.'
}

####MAIN LOOP STRUCTURE#####################################

if [[ "$#" == 0 ]]
then
    help_usage
    exit 1
elif [[ "$#" == 1 ]]
then
    output_domain_names
else
    while getopts ahn opt;
    do
       case $opt in
          a) output_domain_names && output_ip_addresses;;
          h) help_usage;;
          n) output_ip_addresses;;
       esac
    done
fi

####COMMENTS SECTION########################################

#### greycat says:
#### three choices at the start of the script are:
#### $# == 0 which is an error; or
#### $# == 1 which means you have a URL & no options (can skip the loop if you wish); or
#### $# >  1 which means you have to process options
#### if (($# == 0)) before the entire loop
