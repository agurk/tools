#!/usr/bin/bash
#
# Date:   December 2009
#
# A script to list the perms down to the root for a file

VERBOSE=0

function check_set
{
	if [[ -z $1 ]]
	then
		echo $2
		exit 1
	fi
}

function verbose_log
{
	if [[ VERBOSE -eq 1 ]]
	then
		echo $1
	fi
}

function usage
{
	cat << EOF
	usage $0 options

	A script that will start from the current dir, and recurse to root list the permissions for each dir

	OPTIONS:
	-v Be verbose
	-h This screen 
EOF
}

while getopts "vh" OPTION
do
	case $OPTION in
	v)
		VERBOSE=1
		;;
	h)
		usage
		exit 1
		;;
	*)
		usage
		exit 1
		;;
	esac
done
shift $(($OPTIND - 1))

IFS=$'\n'
CHAR_STR=""
while [[ ! `pwd` == "/" ]]
do
	GREP_STR=$(pwd | awk -F/ '{print $NF }')
	verbose_log "Looking in `pwd`"
	verbose_log "looking for dir $GREP_STR"
	for i in $(ls -l ../ | grep $GREP_STR)
	do
		if [[ $(echo $i| awk '{print $8}') == $GREP_STR ]]
		then
			echo $CHAR_STR$i
		fi
	done
	# Now lets get ready for the next iteration!
	if [[ -z $CHAR_STR ]]
	then
		CHAR_STR="->"
	else
		CHAR_STR="--$CHAR_STR"
	fi
	cd ../
done

