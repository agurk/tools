#!/usr/bin/bash

CONFIG_FILE="$HOME/tools/connect_config.sh"

#### CONFIG FILE ##########################################
#### There should be a file for the config in the format ##
#
# AUTH_FILE="/path/to/file"
#
# declare -A SERVERS
# SERVERS[EXAMPLE]=user@server.com
#
# declare -A AUTHFILES
# AUTHFILES[EXAMPLE]=AUTH_FILE
###########################################################

if [[ -e $CONFIG_FILE ]]; then
    source $CONFIG_FILE;
else
    echo "Missing config file: $CONFIG_FILE"
fi


ENV=$1

old_ps1=$PS1
ps1="\[\e]0;$ENV\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ "

function usage
{
    cat<<EOF
usage: connect.sh <env-name>

EOF
    echo Configured environments are:
    paste <(
    for k in "${!SERVERS[@]}"
    do
	echo "$k"
    done
    ) <(
    for k in "${!SERVERS[@]}"
    do
        echo "${SERVERS[$k]}"
    done

    )
}

if [[ -z $ENV ]]
    then
	usage;
	exit 1
elif [[ ${SERVERS[$ENV]} ]]
    then
	if [[ ${AUTHFILES[$ENV]} ]]
	    then
		echo $PS1
		echo $ps1
		export PS1=$ps1
		echo $PS1
		echo ssh -i "${AUTHFILES[$ENV]}" ${SERVERS[$ENV]}
		ssh -i "${AUTHFILES[$ENV]}" ${SERVERS[$ENV]}
	else
		PS1=$ps1
		echo ssh ${SERVERS[$ENV]}
		ssh ${SERVERS[$ENV]}
	fi
else
    echo Unknown environment: $ENV
    usage
fi

