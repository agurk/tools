#!/bin/bash
#
# Script to count the number of a specified character on a given
# line, or all lines if not given 

CHARACTER="|"
FILE=
HUMAN=0
LINENUMBERS=0

currentLines=0
delimiterCount=0


function usage
{
	cat << EOF
	usage: $0 options -f <filename>

	This script counts the number of characters in a file
	and gives information on a per-line basis.

	OPTIONS:
	   -f	File Name
	   -c   Character being counted, defaults to |
	   -h   Human readable (fancy)
	   -l   Show line numbers
EOF
}


while getopts "f:c:hl" OPTION
do
	case $OPTION in
	f)
		FILE=$OPTARG
		;;
	c)
		CHARACTER=$OPTARG
		;;
	h)
		HUMAN=1
		;;
	l)
		LINENUMBERS=1
		;;
	esac
done

if [[ -z "$FILE" ]]; then
	usage
	exit 1
fi

if [[ $HUMAN -eq 1 ]]; then
	echo "Chars in $FILE"
	echo "------"
fi

IFS=$'\n'
for i in $(cat $FILE); do
		currentLines=$(($currentLines + 1))
		numberOfDelim=$(echo -n $i | sed s/[^"$CHARACTER"]//g | wc -m)
		delimiterCount=$((delimiterCount + $numberOfDelim))
		if [[ $LINENUMBERS -eq 1 ]]; then
			echo "$currentLines: $numberOfDelim"
		else
			echo "$numberOfDelim"
		fi
done
unset IFS

if [[ $currentLines -eq 0 ]]; then
	echo "Character does not occur in file"
	exit 1
fi

if [[ $HUMAN -eq 1 ]]; then
	echo "------"
	echo "Total $CHARACTER : $delimiterCount"
	echo "Total lines: $(cat $FILE | wc -l)"
	echo "------"
fi

if [ $currentLines != $(cat $FILE | wc -l) ];
then
	echo "-!!!!!!!!!!!!!!!'-"
	echo "Warning blank lines in file, line numbers incorrect"
	echo "-!!!!!!!!!!!!!!!'-"
fi
